import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
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

  double _textFieldHeight = 50;
  double _chatContainerHeight = 130;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();

    changeNotificationType(OSNotificationDisplayType.none);
    getPreviousMessages();

//    KeyboardVisibility.onChange.listen((bool visible) {
//      print('Keyboard visibility update. Is visible: ${visible}');
//      if(visible){
//     //   scrollController.animateTo(scrollController.position.ma, duration: null, curve: null)
//      }
//    });

//    messageTextController.addListener(() {
//      int count = messageTextController.text.split('\n').length;
//
//      if (count > 0) {
//        setState(() {
//          _textFieldHeight = (50 * count).toDouble();
//          _chatContainerHeight = (130 * count).toDouble();
//        });
//      }
//    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        changeNotificationType(OSNotificationDisplayType.notification);

        realTimeController.updateUnreadMessages(widget.presenter.id);
        realTimeController.clearDirectMessageStream();

        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            elevation: 0,
            title: Text(widget.presenter.name),
          ),
          body: StreamBuilder<List<DirectMessage>>(
              stream: realTimeController.directMessageStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<DirectMessage>> snapshot) {
                if (snapshot.data != null) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                          height: MediaQuery.of(context).size.height -
                              _chatContainerHeight,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(16),
                              reverse: true,
                              controller: scrollController,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Row(
                                    mainAxisAlignment:
                                        snapshot.data[index].receiverId ==
                                                customerId
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.end,
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        elevation: 0,
                                        color:
                                            snapshot.data[index].receiverId ==
                                                    customerId
                                                ? Colors.grey[200]
                                                : Colors.black,
                                        child: snapshot
                                                    .data[index].body.length >
                                                10
                                            ? Container(
                                                width: 3 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        4 -
                                                    100,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        snapshot
                                                            .data[index].body,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: snapshot
                                                                      .data[
                                                                          index]
                                                                      .receiverId ==
                                                                  customerId
                                                              ? Colors.black
                                                              : Colors.white,
                                                        ),
                                                        softWrap: true,
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
                                                            DateFormat(
                                                                    'HH:mm a')
                                                                .format(snapshot
                                                                    .data[index]
                                                                    .createdAt),
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color: snapshot
                                                                          .data[
                                                                              index]
                                                                          .receiverId ==
                                                                      customerId
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
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
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        snapshot
                                                            .data[index].body,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: snapshot
                                                                      .data[
                                                                          index]
                                                                      .receiverId ==
                                                                  customerId
                                                              ? Colors.black
                                                              : Colors.white,
                                                        ),
                                                        softWrap: true,
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
                                                            DateFormat(
                                                                    'HH:mm a')
                                                                .format(snapshot
                                                                    .data[index]
                                                                    .createdAt),
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color: snapshot
                                                                          .data[
                                                                              index]
                                                                          .receiverId ==
                                                                      customerId
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
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
                                  )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextField(
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
                                      Logger().d(messageTextController.text);
                                      new RealTimeController()
                                          .sendDirectMessage(new DirectMessage(
                                        body: messageTextController.text,
                                        userId: customerId,
                                        createdAt: new DateTime.now(),
                                        receiverId: widget.presenter.id,
                                      ));
                                      messageTextController.clear();
                                    },
                                    icon: Icon(Icons.send)),
                                enabledBorder: OutlineInputBorder(
                                    gapPadding: 2,
//                                      borderRadius: const BorderRadius.all(
//                                        const Radius.circular(30.0),
//                                      ),
                                    borderSide: BorderSide(
                                      width: 0.5,
                                      color: Colors.black54,
                                    )),
                                focusedBorder: OutlineInputBorder(
//                                      borderRadius: const BorderRadius.all(
//                                        const Radius.circular(30.0),
//                                      ),
                                    borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.1))),
                                border: OutlineInputBorder(
//                                      borderRadius: const BorderRadius.all(
//                                        const Radius.circular(30.0),
//                                      ),
                                    borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.1))),
                                hintText: "Type your message"),
                          ),
                        ),
                      ],
                    ),
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
