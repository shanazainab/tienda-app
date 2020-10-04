import 'dart:ui';

import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:jiffy/jiffy.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/controller/live-chat-container-controller.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/live-chat.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/view/live-stream/live-chat-container.dart';

typedef ClosePanel = Function(bool shouldClose);

class LiveChatPanel extends StatefulWidget {
  LiveChatPanel({
    Key key,
    @required this.presenter,
    @required this.closePanel,
  }) : super(key: key);
  final ClosePanel closePanel;
  final Presenter presenter;

  @override
  _LiveChatPanelState createState() => _LiveChatPanelState();
}

class _LiveChatPanelState extends State<LiveChatPanel> {
  final FocusNode textFocusNode = new FocusNode();
  final RealTimeController realTimeController = new RealTimeController();
  final ScrollController scrollController = new ScrollController();
  final TextEditingController textEditingController =
      new TextEditingController();

  double height;
  double mheight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print("FROM PANEL: $visible");

        setState(() {
          height = visible
              ? MediaQuery.of(context).size.height * 33 / 100 / 4
              : MediaQuery.of(context).size.height * 33 / 100;

          mheight = visible
              ? MediaQuery.of(context).size.height * 50 / 100 / 2
              : MediaQuery.of(context).size.height * 50 / 100;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Colors.white,
      duration: Duration(milliseconds: 250),
      height: mheight == null
          ? MediaQuery.of(context).size.height * 50 / 100
          : mheight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0, top: 14),
                    child: Text(
                      "All about hivebox freezer ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0, top: 2),
                    child: StreamBuilder<String>(
                        stream: new RealTimeController().viewCountStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(snapshot.data == null
                                ? "1 watching now"
                                : "${snapshot.data} watching now"),
                          );
                        }),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    widget.closePanel(true);
                  },
                  icon: Icon(Icons.close))
            ],
          ),
          SizedBox(
            height: 8,
          ),
          AnimatedContainer(
              duration: Duration(milliseconds: 250),
              height: height == null
                  ? MediaQuery.of(context).size.height * 33 / 100
                  : height,
              child: StreamBuilder<List<LiveChat>>(
                  stream: realTimeController.liveChatStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<LiveChat>> snapshot) {
                    if (snapshot.data != null)
                      return FadingEdgeScrollView.fromScrollView(
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 16),
                          shrinkWrap: true,
                          reverse: true,
                          controller: scrollController,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.grey,
                                        backgroundImage: NetworkImage(
                                            "${GlobalConfiguration().getString("imageURL")}/${snapshot.data[index].profileImageUrl}"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data[index].senderName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    "${Jiffy.unix(snapshot.data[index].dateTime).fromNow()}",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              snapshot.data[index].body,
                                              style: TextStyle(),
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    else
                      return Container(
                      );
                  })),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 42,
                  width: 3 * MediaQuery.of(context).size.width / 4,
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    focusNode: textFocusNode,
                    controller: textEditingController,
                    decoration: InputDecoration(
                        filled: true,
                        suffixIcon: IconButton(
                            onPressed: () {
                              if (textEditingController.text != null &&
                                  textEditingController.text.length != 0) {
                                new RealTimeController().emitLiveMessage(
                                    textEditingController.text,
                                    widget.presenter.id);
                                textEditingController.clear();
                              }
                            },
                            icon: Text(
                              "Send",
                              style: TextStyle(
                                  color: Color(0xFF2dab90),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            )),
                        hintStyle:
                            TextStyle(fontSize: 13, color: Color(0xFF555555)),
                        contentPadding: EdgeInsets.only(
                            left: 16, top: 0, bottom: 0, right: 0),
                        fillColor: Colors.white,
                        // focusColor: Colors.black.withOpacity(0.1),
                        enabledBorder: OutlineInputBorder(
                            gapPadding: 2,
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(60.0),
                            ),
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.black,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(60.0),
                            ),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.1))),
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(60.0),
                            ),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.1))),
                        hintText: "Chat with ${widget.presenter.name}"),
                  ),
                ),
              ),
              IconButton(
                constraints: BoxConstraints.tight(Size.square(40)),
                padding: EdgeInsets.all(0),
                onPressed: () {
                  realTimeController.showLiveReaction(widget.presenter.id);
                },
                icon: SvgPicture.asset(
                  "assets/svg/heart.svg",
                ),
              ),
              SizedBox(
                width: 2,
              )
            ],
          ),
        ],
      ),
    );
  }
}
