import 'dart:ui';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:jiffy/jiffy.dart';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';

import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/model/live-chat.dart';

import '../../localization.dart';

class LiveCommentBox extends StatefulWidget {
  final int presenterId;

  LiveCommentBox(this.presenterId);

  @override
  _State createState() => _State();
}

class _State extends State<LiveCommentBox> {
  RealTimeController realTimeController = new RealTimeController();

  final FocusNode textFocusNode = new FocusNode();

  ScrollController scrollController = new ScrollController();
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return ListView(
      shrinkWrap: true,
      children: [
        StreamBuilder<List<LiveChat>>(
            stream: realTimeController.liveChatStream,
            builder:
                (BuildContext context, AsyncSnapshot<List<LiveChat>> snapshot) {
              if (snapshot.data != null)
                return Container(
                  height: 190,
                  child: FadingEdgeScrollView.fromScrollView(

                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 16),
                      shrinkWrap: true,
                      reverse: true,
                      controller: scrollController,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) =>
                     Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            color:  snapshot.data[index].isPremium != null && snapshot.data[index].isPremium?Colors.redAccent:Colors.black54,

                            // color: Colors.black.withOpacity(0.1),
                            elevation: snapshot.data[index].isPremium != null && snapshot.data[index].isPremium?8:0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
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
                                        left: 4.0, right: 4.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        snapshot.data[index].body.length > 60
                                            ? Container(
                                                width: 3 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        4 -
                                                    55,
                                                child: Text(
                                                  snapshot.data[index].body,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                  softWrap: true,
                                                ),
                                              )
                                            : Text(
                                                snapshot.data[index].body,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                                softWrap: true,
                                              ),
                                        Row(
                                          children: [
                                            Text(
                                              snapshot.data[index].senderName,
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "${Jiffy.unix(snapshot.data[index].dateTime).fromNow()}",
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        // snapshot.data[index].isPremium != null && snapshot.data[index].isPremium?Icon(Icons.star,
                                        // color: Colors.amber,):Container()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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

        ///Chat text field

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
            child: SizedBox(
              width: 3 * MediaQuery.of(context).size.width / 4,
              height: 40,
              child: TextField(
                focusNode: textFocusNode,
                controller: textEditingController,
                onSubmitted: (value) {
                  if(value != null && value.length!=0) {
                    Logger().d(value);
                    new RealTimeController()
                        .emitLiveMessage(value, widget.presenterId);
                     textEditingController.clear();
                  }
                },
                style: TextStyle(
                  color: Colors.white
                ),
                decoration: InputDecoration(
                    filled: true,
                    hintStyle: TextStyle(fontSize: 12, color: Colors.white),
                    contentPadding:
                        EdgeInsets.only(left: 16, top: 0, bottom: 0, right: 0),
                    // fillColor: Colors.black.withOpacity(0.1),

                    fillColor: Colors.black54,
                    focusColor: Colors.black.withOpacity(0.1),
                    enabledBorder: OutlineInputBorder(
                        gapPadding: 2,
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.black54,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                        borderSide:
                            BorderSide(color: Colors.black.withOpacity(0.1))),
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                        borderSide:
                            BorderSide(color: Colors.black.withOpacity(0.1))),
                    hintText: AppLocalizations.of(context)
                        .translate("type-your-comment")),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
