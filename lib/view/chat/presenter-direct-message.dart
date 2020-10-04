import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/controller/one-signal-notification-controller.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/model/get-chat-message-response.dart';
import 'package:tienda/model/presenter.dart';

class PresenterDirectMessage extends StatefulWidget {
  final Presenter presenter;

  PresenterDirectMessage(this.presenter);

  @override
  _PresenterDirectMessageState createState() => _PresenterDirectMessageState();
}

class _PresenterDirectMessageState extends State<PresenterDirectMessage> {
  RealTimeController realTimeController = new RealTimeController();

  TextEditingController messageTextController = new TextEditingController();
  FocusNode _focusNode = new FocusNode();
  String customerName;
  int customerId;

  ScrollController scrollController = new ScrollController();
  double containerHeight = 200;

  final groupedMessageStream =
      BehaviorSubject<Map<String, List<DirectMessage>>>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    realTimeController.updateUnreadMessages(widget.presenter.id);
    getUserDetails();

    changeNotificationType(OSNotificationDisplayType.none);
    getPreviousMessages();

    realTimeController.directMessageStream.listen((value) {
      List<DirectMessage> messages = value;

      Logger().d("DIRECT MESSAGE:$messages");
      // if (messages.length > 1) {
      //   messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      // }
      // messages.reversed.toList();
      log(messages.toString());
      Map<String, List<DirectMessage>> groupedMessages = new HashMap();

      if(messages != null) {
        for (final message in messages) {
          if (groupedMessages
              .containsKey(message.createdAt.toString().substring(0, 10))) {
            groupedMessages[message.createdAt.toString().substring(0, 10)]
                .add(message);
          } else {
            groupedMessages[message.createdAt.toString().substring(0, 10)] =
            new List()
              ..add(message);
          }
        }
      }
      log(groupedMessages.toString());
      groupedMessageStream.sink.add(groupedMessages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        changeNotificationType(OSNotificationDisplayType.notification);

        // realTimeController.updateUnreadMessages(widget.presenter.id);
        realTimeController.clearDirectMessageStream();

        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            elevation: 0,
            title: Text(widget.presenter.name),
          ),
          body: StreamBuilder<Map<String, List<DirectMessage>>>(
              stream: groupedMessageStream,
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, List<DirectMessage>>> snapshot) {
                if (snapshot.data != null) {
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                              height: MediaQuery.of(context).size.height -
                                  containerHeight,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(16),
                                  reverse: true,
                                  physics: ScrollPhysics(),
                                  itemCount: snapshot.data.keys.toList().length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          Column(
                                            children: [
                                              Card(
                                                  color: Colors.lightBlueAccent,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4,
                                                            bottom: 4,
                                                            left: 8.0,
                                                            right: 8),
                                                    child: Text(
                                                      snapshot.data.keys
                                                          .toList()
                                                          .reversed
                                                          .toList()[index],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10),
                                                    ),
                                                  )),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: ScrollPhysics(),
                                                reverse: true,
                                                itemCount: snapshot
                                                    .data[snapshot.data.keys
                                                        .toList()
                                                        .reversed
                                                        .toList()[index]]
                                                    .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                            int subIndex) =>
                                                        Row(
                                                  mainAxisAlignment: snapshot
                                                              .data[snapshot
                                                                      .data.keys
                                                                      .toList()
                                                                      .reversed
                                                                      .toList()[
                                                                  index]][subIndex]
                                                              .receiverId ==
                                                          customerId
                                                      ? MainAxisAlignment.start
                                                      : MainAxisAlignment.end,
                                                  children: [
                                                    Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                      elevation: 0,
                                                      color: snapshot
                                                                  .data[snapshot
                                                                      .data.keys
                                                                      .toList()
                                                                      .reversed
                                                                      .toList()[index]][subIndex]
                                                                  .receiverId ==
                                                              customerId
                                                          ? Colors.grey[200]
                                                          : Colors.black,
                                                      child: snapshot
                                                                  .data[snapshot
                                                                      .data.keys
                                                                      .toList()
                                                                      .reversed
                                                                      .toList()[index]][subIndex]
                                                                  .body
                                                                  .length >
                                                              10
                                                          ? Container(
                                                              width: 3 *
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      4 -
                                                                  100,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Text(
                                                                      snapshot
                                                                          .data[snapshot
                                                                              .data
                                                                              .keys
                                                                              .toList()
                                                                              .reversed
                                                                              .toList()[index]][subIndex]
                                                                          .body,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: snapshot.data[snapshot.data.keys.toList().reversed.toList()[index]][subIndex].receiverId ==
                                                                                customerId
                                                                            ? Colors.black
                                                                            : Colors.white,
                                                                      ),
                                                                      softWrap:
                                                                          true,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          DateFormat('HH:mm a').format(snapshot
                                                                              .data[snapshot.data.keys.toList().reversed.toList()[index]][subIndex]
                                                                              .createdAt),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color: snapshot.data[snapshot.data.keys.toList().reversed.toList()[index]][subIndex].receiverId == customerId
                                                                                ? Colors.black
                                                                                : Colors.white,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : Container(
                                                              width: 100,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      snapshot
                                                                          .data[snapshot
                                                                              .data
                                                                              .keys
                                                                              .toList()
                                                                              .reversed
                                                                              .toList()[index]][subIndex]
                                                                          .body,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: snapshot.data[snapshot.data.keys.toList().reversed.toList()[index]][subIndex].receiverId ==
                                                                                customerId
                                                                            ? Colors.black
                                                                            : Colors.white,
                                                                      ),
                                                                      softWrap:
                                                                          true,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          DateFormat('HH:mm a').format(snapshot
                                                                              .data[snapshot.data.keys.toList().reversed.toList()[index]]
                                                                              .reversed
                                                                              .toList()[subIndex]
                                                                              .createdAt),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color: snapshot.data[snapshot.data.keys.toList().reversed.toList()[index]][subIndex].receiverId == customerId
                                                                                ? Colors.black
                                                                                : Colors.white,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

//                                    Text(snapshot.data[index].body,
//                                      softWrap: true,),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                //focusNode: textFocusNode,

                                minLines: 1,
                                maxLines: 4,
                                keyboardType: TextInputType.multiline,
                                onSubmitted: (value) {
                                  print("search");
                                },
                                controller: messageTextController,

                                decoration: InputDecoration(
                                    filled: true,
                                    hintStyle: TextStyle(fontSize: 12),
                                    contentPadding: EdgeInsets.only(
                                        left: 16, top: 0, bottom: 0, right: 0),
                                    // fillColor: Colors.black.withOpacity(0.1),

                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          messageTextController.text.trim();
                                          // ^[a-zA-Z0-9_.-]*$

//                                      if(messageTextController.text.contains(Pattern(
//
//                                      )))
                                          print(messageTextController.text);
                                          if (messageTextController.text !=
                                              "") {
                                            print("entered");

                                            new RealTimeController()
                                                .sendDirectMessage(
                                                    new DirectMessage(
                                              body: messageTextController.text,
                                              userId: customerId,
                                              createdAt: new DateTime.now(),
                                              receiverId: widget.presenter.id,
                                            ));
                                            messageTextController.clear();
                                          }
                                        },
                                        icon: Icon(Icons.send)),
                                    enabledBorder: OutlineInputBorder(
                                        gapPadding: 2,
//                                    borderRadius: const BorderRadius.all(
//                                      const Radius.circular(30.0),
//                                    ),
                                        borderSide: BorderSide(
                                          width: 0.5,
                                          color: Colors.black54,
                                        )),
                                    focusedBorder: OutlineInputBorder(
//                                    borderRadius: const BorderRadius.all(
//                                      const Radius.circular(30.0),
//                                    ),
                                        borderSide: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.1))),
                                    border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(30.0),
                                        ),
                                        borderSide: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.1))),
                                    hintText: "Type your message"),
                              ),
                            ),
                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child: ScrollToBottom(),
                            // )
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                }
              })),
    );
  }

  Future<void> getUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    customerName = sharedPreferences.getString('customer-name');
    customerId = sharedPreferences.getInt('customer-id');
    setState(() {});
  }

  void getPreviousMessages() {
    realTimeController.getPresenterChats(widget.presenter.id);
  }

  void changeNotificationType(OSNotificationDisplayType type) {
    OneSignalNotificationController().changeNotificationType(type);
  }
}

class ScrollToBottom extends StatelessWidget {
  final Function onScrollToBottomPress;
  final ScrollController scrollController;
  final bool inverted;

  ScrollToBottom({
    this.onScrollToBottomPress,
    this.scrollController,
    this.inverted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: RawMaterialButton(
        elevation: 5,
        fillColor: Theme.of(context).primaryColor,
        shape: CircleBorder(),
        child: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
        onPressed: () {
          if (onScrollToBottomPress != null) {
            onScrollToBottomPress();
          } else {
            scrollController.animateTo(
              inverted ? 0.0 : scrollController.position.maxScrollExtent + 25.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
      ),
    );
  }
}
