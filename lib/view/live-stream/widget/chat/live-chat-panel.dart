import 'dart:ui';

import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/model/live-chat.dart';
import 'package:tienda/model/live-reaction.dart';
import 'package:tienda/model/live-response.dart';
import 'package:tienda/model/presenter.dart';

typedef ClosePanel = Function(bool shouldClose);

class LiveChatPanel extends StatefulWidget {
  LiveChatPanel({
    Key key,
    @required this.presenter,
    @required this.closePanel,
    @required this.liveResponse,
  }) : super(key: key);
  final ClosePanel closePanel;
  final Presenter presenter;
  final LiveResponse liveResponse;

  @override
  _LiveChatPanelState createState() => _LiveChatPanelState();
}

class _LiveChatPanelState extends State<LiveChatPanel> {
  final FocusNode textFocusNode = new FocusNode();
  final RealTimeController realTimeController = new RealTimeController();
  final ScrollController scrollController = new ScrollController();
  final TextEditingController textEditingController =
      new TextEditingController();

  final FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 340,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 100,
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
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    radius: 16,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    backgroundImage: NetworkImage(
                                                        "${GlobalConfiguration().getString("imageURL")}/${snapshot.data[index].profileImageUrl}"),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              snapshot
                                                                          .data[
                                                                              index]
                                                                          .senderName ==
                                                                      null
                                                                  ? "Test"
                                                                  : snapshot
                                                                      .data[
                                                                          index]
                                                                      .senderName,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                              child: Text(
                                                                "${Jiffy.unix(snapshot.data[index].dateTime).fromNow()}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          snapshot
                                                              .data[index].body,
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
                                  return Container();
                              }),
                        ),
                        StreamBuilder<LiveReaction>(
                            stream: realTimeController.liveReaction,
                            builder: (BuildContext context,
                                AsyncSnapshot<LiveReaction> snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data.showReaction)
                                return Container(
                                  width: 100,
                                  alignment: Alignment.bottomCenter,
                                  child: Lottie.asset(
                                      'assets/animations/heart-burst.json'),
                                );
                              else
                                return Container();
                            })
                      ],
                    ),
                  ),
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
                            focusNode: focusNode,
                            controller: textEditingController,
                            decoration: InputDecoration(
                                filled: true,
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      if (textEditingController.text != null &&
                                          textEditingController.text.length !=
                                              0) {
                                        new RealTimeController()
                                            .emitLiveMessage(
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
                                hintStyle: TextStyle(
                                    fontSize: 13, color: Color(0xFF555555)),
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
                          realTimeController
                              .emitLiveReaction(widget.presenter.id);
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
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0, top: 14),
                        child: Text(
                          widget.liveResponse.title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
            ),
          ],
        ),
      ),
    );

    // return AnimatedContainer(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.only(
    //         topRight: Radius.circular(12), topLeft: Radius.circular(12)),
    //     color: Colors.white,
    //   ),
    //   curve: Curves.easeOut,
    //   duration: Duration(milliseconds: 200),
    //   height: mheight == null
    //       ? MediaQuery.of(context).size.height * 50 / 100
    //       : mheight,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     mainAxisSize: MainAxisSize.max,
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 14.0, top: 14),
    //                 child: Text(
    //                   "All about hivebox freezer ",
    //                   style:
    //                       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 14.0, top: 2),
    //                 child: StreamBuilder<String>(
    //                     stream: new RealTimeController().viewCountStream,
    //                     builder: (BuildContext context,
    //                         AsyncSnapshot<String> snapshot) {
    //                       return Padding(
    //                         padding: const EdgeInsets.only(top: 4.0),
    //                         child: Text(snapshot.data == null
    //                             ? "1 watching now"
    //                             : "${snapshot.data} watching now"),
    //                       );
    //                     }),
    //               ),
    //             ],
    //           ),
    //           IconButton(
    //               onPressed: () {
    //                 widget.closePanel(true);
    //               },
    //               icon: Icon(Icons.close))
    //         ],
    //       ),
    //       SizedBox(
    //         height: 8,
    //       ),
    //       AnimatedContainer(
    //           duration: Duration(milliseconds: 200),
    //           curve: Curves.easeOut,
    //           height: height == null
    //               ? MediaQuery.of(context).size.height * 40 / 100
    //               : height,
    //           child: Row(
    //             children: [
    //               Container(
    //                 width: MediaQuery.of(context).size.width - 100,
    //                 child: StreamBuilder<List<LiveChat>>(
    //                     stream: realTimeController.liveChatStream,
    //                     builder: (BuildContext context,
    //                         AsyncSnapshot<List<LiveChat>> snapshot) {
    //                       if (snapshot.data != null)
    //                         return FadingEdgeScrollView.fromScrollView(
    //                           child: ListView.builder(
    //                             padding: EdgeInsets.only(top: 16),
    //                             shrinkWrap: true,
    //                             reverse: true,
    //                             controller: scrollController,
    //                             itemCount: snapshot.data.length,
    //                             itemBuilder:
    //                                 (BuildContext context, int index) =>
    //                                     Padding(
    //                               padding: const EdgeInsets.all(8.0),
    //                               child: Row(
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 children: [
    //                                   Padding(
    //                                     padding: const EdgeInsets.all(2.0),
    //                                     child: Row(
    //                                       mainAxisSize: MainAxisSize.min,
    //                                       children: <Widget>[
    //                                         CircleAvatar(
    //                                           radius: 16,
    //                                           backgroundColor: Colors.grey,
    //                                           backgroundImage: NetworkImage(
    //                                               "${GlobalConfiguration().getString("imageURL")}/${snapshot.data[index].profileImageUrl}"),
    //                                         ),
    //                                         Padding(
    //                                           padding: const EdgeInsets.only(
    //                                               left: 8.0, right: 8.0),
    //                                           child: Column(
    //                                             mainAxisSize: MainAxisSize.min,
    //                                             crossAxisAlignment:
    //                                                 CrossAxisAlignment.start,
    //                                             mainAxisAlignment:
    //                                                 MainAxisAlignment.start,
    //                                             children: [
    //                                               Row(
    //                                                 children: [
    //                                                   Text(
    //                                                     snapshot.data[index]
    //                                                                 .senderName ==
    //                                                             null
    //                                                         ? "Test"
    //                                                         : snapshot
    //                                                             .data[index]
    //                                                             .senderName,
    //                                                     style: TextStyle(
    //                                                         fontWeight:
    //                                                             FontWeight
    //                                                                 .bold),
    //                                                   ),
    //                                                   Padding(
    //                                                     padding:
    //                                                         const EdgeInsets
    //                                                                 .only(
    //                                                             left: 8.0),
    //                                                     child: Text(
    //                                                       "${Jiffy.unix(snapshot.data[index].dateTime).fromNow()}",
    //                                                       style: TextStyle(
    //                                                           fontSize: 12),
    //                                                     ),
    //                                                   ),
    //                                                 ],
    //                                               ),
    //                                               Text(
    //                                                 snapshot.data[index].body,
    //                                                 style: TextStyle(),
    //                                                 softWrap: true,
    //                                               ),
    //                                             ],
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                           ),
    //                         );
    //                       else
    //                         return Container();
    //                     }),
    //               ),
    //               StreamBuilder<LiveReaction>(
    //                   stream: realTimeController.liveReaction,
    //                   builder: (BuildContext context,
    //                       AsyncSnapshot<LiveReaction> snapshot) {
    //                     if (snapshot.hasData && snapshot.data.showReaction)
    //                       return Container(
    //                         width: 100,
    //                         alignment: Alignment.bottomCenter,
    //                         height: height == null
    //                             ? MediaQuery.of(context).size.height * 40 / 100
    //                             : height,
    //                         child: Lottie.asset(
    //                             'assets/animations/heart-burst.json'),
    //                       );
    //                     else
    //                       return Container();
    //                   })
    //             ],
    //           )),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: SizedBox(
    //               height: 42,
    //               width: 3 * MediaQuery.of(context).size.width / 4,
    //               child: TextField(
    //                 minLines: 1,
    //                 maxLines: 4,
    //                 keyboardType: TextInputType.multiline,
    //                 focusNode: focusNode,
    //                 controller: textEditingController,
    //                 decoration: InputDecoration(
    //                     filled: true,
    //                     suffixIcon: IconButton(
    //                         onPressed: () {
    //                           if (textEditingController.text != null &&
    //                               textEditingController.text.length != 0) {
    //                             new RealTimeController().emitLiveMessage(
    //                                 textEditingController.text,
    //                                 widget.presenter.id);
    //                             textEditingController.clear();
    //                           }
    //                         },
    //                         icon: Text(
    //                           "Send",
    //                           style: TextStyle(
    //                               color: Color(0xFF2dab90),
    //                               fontWeight: FontWeight.bold,
    //                               fontSize: 12),
    //                         )),
    //                     hintStyle:
    //                         TextStyle(fontSize: 13, color: Color(0xFF555555)),
    //                     contentPadding: EdgeInsets.only(
    //                         left: 16, top: 0, bottom: 0, right: 0),
    //                     fillColor: Colors.white,
    //                     // focusColor: Colors.black.withOpacity(0.1),
    //                     enabledBorder: OutlineInputBorder(
    //                         gapPadding: 2,
    //                         borderRadius: const BorderRadius.all(
    //                           const Radius.circular(60.0),
    //                         ),
    //                         borderSide: BorderSide(
    //                           width: 0.5,
    //                           color: Colors.black,
    //                         )),
    //                     focusedBorder: OutlineInputBorder(
    //                         borderRadius: const BorderRadius.all(
    //                           const Radius.circular(60.0),
    //                         ),
    //                         borderSide: BorderSide(
    //                             color: Colors.black.withOpacity(0.1))),
    //                     border: OutlineInputBorder(
    //                         borderRadius: const BorderRadius.all(
    //                           const Radius.circular(60.0),
    //                         ),
    //                         borderSide: BorderSide(
    //                             color: Colors.black.withOpacity(0.1))),
    //                     hintText: "Chat with ${widget.presenter.name}"),
    //               ),
    //             ),
    //           ),
    //           IconButton(
    //             constraints: BoxConstraints.tight(Size.square(40)),
    //             padding: EdgeInsets.all(0),
    //             onPressed: () {
    //               realTimeController.emitLiveReaction(widget.presenter.id);
    //             },
    //             icon: SvgPicture.asset(
    //               "assets/svg/heart.svg",
    //             ),
    //           ),
    //           SizedBox(
    //             width: 2,
    //           )
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
