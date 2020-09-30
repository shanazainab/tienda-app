import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tienda/model/live-chat.dart';

class LiveChatContainer extends StatelessWidget {
  const LiveChatContainer({
    Key key,
    @required this.scrollController,
    @required this.liveChats,
  }) : super(key: key);

  final ScrollController scrollController;
  final List<LiveChat> liveChats;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      child: FadingEdgeScrollView.fromScrollView(
        child: ListView.builder(
          padding: EdgeInsets.only(top: 16),
          shrinkWrap: true,
          reverse: true,
          controller: scrollController,
          itemCount: liveChats.length,
          itemBuilder: (BuildContext context, int index) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                color: liveChats[index].isPremium != null &&
                        liveChats[index].isPremium
                    ? Colors.redAccent
                    : Colors.black54,

                // color: Colors.black.withOpacity(0.1),
                elevation: liveChats[index].isPremium != null &&
                        liveChats[index].isPremium
                    ? 8
                    : 0,
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
                            "${GlobalConfiguration().getString("imageURL")}/${liveChats[index].profileImageUrl}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            liveChats[index].body.length > 60
                                ? Container(
                                    width: 3 *
                                            MediaQuery.of(context)
                                                .size
                                                .width /
                                            4 -
                                        55,
                                    child: Text(
                                      liveChats[index].body,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      softWrap: true,
                                    ),
                                  )
                                : Text(
                                    liveChats[index].body,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                    softWrap: true,
                                  ),
                            Row(
                              children: [
                                Text(
                                  liveChats[index].senderName,
                                  style: TextStyle(
                                      fontSize: 8, color: Colors.white),
                                ),
                                Text(
                                  "${Jiffy.unix(liveChats[index].dateTime).fromNow()}",
                                  style: TextStyle(
                                      fontSize: 8, color: Colors.white),
                                ),
                              ],
                            ),
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
  }
}
