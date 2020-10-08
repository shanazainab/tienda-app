import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/events/loading-events.dart';
import 'package:tienda/model/live-contents.dart';

class FeaturedLive extends StatelessWidget {
  final LiveContent liveContent;

  FeaturedLive(this.liveContent);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: 270,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        "${GlobalConfiguration().getString("mediaDevURL")}/${liveContent.presenter.profilePicture}",
                      ),
                      fit: BoxFit.cover,
                    )),
                child: Container()),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left:12.0,top:16),
              child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(0xffff2e63),
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Opacity(
                          opacity: 0.699999988079071,
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: const Color(0xffffffff),
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text("LIVE",
                            style: const TextStyle(
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w700,
                                fontFamily: "SFProDisplay",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            textAlign: TextAlign.center),
                        SizedBox(
                          width: 4,
                        ),
                        Opacity(
                          opacity: 0.699999988079071,
                          child: Text("01:37:50",
                              style: const TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "SFProDisplay",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              textAlign: TextAlign.left),
                        )
                      ],
                    ),
                  )),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                  color: Color(0xffE0E8FF),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text("All About Hivebox Freezer",
                            style: const TextStyle(
                                color: const Color(0xff1a1824),
                                fontWeight: FontWeight.w700,
                                fontFamily: "SFProDisplay",
                                fontStyle: FontStyle.normal,
                                fontSize: 20.0),
                            textAlign: TextAlign.left),
                        SizedBox(
                          height: 1,
                        ),
                        Text("Remote Freezer best review",
                            style: const TextStyle(
                                color: const Color(0xff1a1824),
                                fontWeight: FontWeight.w400,
                                fontFamily: "SFProDisplay",
                                fontStyle: FontStyle.normal,
                                fontSize: 13.0),
                            textAlign: TextAlign.left),
                        SizedBox(
                          height: 4,
                        ),
                        Text("432 views • 25 comments",
                            style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              color: Color(0xff1a1824),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 44,
                      width: 44,
                      child: FloatingActionButton(
                          onPressed: () {},
                          backgroundColor: Color(0xffFF5C29),
                          child: Icon(Icons.play_arrow)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
