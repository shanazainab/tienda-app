import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';
import 'package:tienda/bloc/events/presenter-message-events.dart';
import 'package:tienda/bloc/states/live-stream-states.dart';
import 'package:tienda/bloc/states/presenter-message-states.dart';
import 'package:tienda/bloc/unreadmessage-bloc.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/model/chat-history-response.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/model/unread-messages.dart';
import 'package:tienda/view/chat/presenter-direct-message.dart';

class ChatHistory extends StatefulWidget {
  @override
  _ChatHistoryState createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  RealTimeController realTimeController = new RealTimeController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    realTimeController.unReadMessage.listen((value) {
      Logger().d("UNREAD LISTNER CALLED");
      if (value != null) {
        BlocProvider.of<UnreadMessageHydratedBloc>(context)
            .add(MessageReceivedEvent(value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          centerTitle: false,
          title: Text("MESSAGES"),
        ),
        body: Container(
          color: Colors.white,
          child: StreamBuilder<List<Message>>(
              stream: RealTimeController().allMessageStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Message>> snapshot) {
                if (snapshot.data != null)
                  return Container(
                    color: Colors.white,
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                              color: Colors.grey[200],
                              indent: 20,
                              endIndent: 0,
                            ),
                        shrinkWrap: true,
                        padding: EdgeInsets.all(16),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) =>
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PresenterDirectMessage(Presenter(
                                              name: snapshot.data[index].name,
                                              id: snapshot.data[index].id))),
                                );
                              },
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [

                                          ///presenter image
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.grey[200],
                                            backgroundImage: NetworkImage(
                                                "${GlobalConfiguration().getString('imageURL')}/${snapshot.data[index].profilePicture}"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    snapshot.data[index].name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                ),

                                                ///TODO:HYDRATED BLOC

                                                BlocBuilder<
                                                        UnreadMessageHydratedBloc,
                                                        PresenterMessageStates>(
                                                    builder: (context, state) {
                                                  if (state
                                                          is MessageReceivedSuccess &&
                                                      state.unReadMessages.contains(
                                                          new UnreadMessage(
                                                              presenterId:
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .id)))
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        state
                                                            .unReadMessages[
                                                                index]
                                                            .messages[state
                                                                .unReadMessages[
                                                                    index]
                                                                .messages
                                                                .length -
                                                            1],
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    );
                                                  else {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        snapshot.data[index]
                                                            .lastMessage,
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    );
                                                  }
                                                })
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      ///TODO:HYDRATED BLOC

                                      BlocBuilder<UnreadMessageHydratedBloc,
                                              PresenterMessageStates>(
                                          builder: (context, state) {
                                        if (state is MessageReceivedSuccess &&
                                            state.unReadMessages.contains(
                                                new UnreadMessage(
                                                    presenterId: snapshot
                                                        .data[index].id)))
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(Jiffy.unix(state
                                                      .unReadMessages[index]
                                                      .elapsedTime)
                                                  .fromNow()),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  child: Text(
                                                    state.unReadMessages[index]
                                                        .messages.length
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        else {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snapshot.data[index].elapsedTime,
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          );
                                        }
                                      })

                                    ],
                                  ),
                                ),
                              ),
                            )),
                  );
                else
                  return Container();
              }),
        ));
  }
}
