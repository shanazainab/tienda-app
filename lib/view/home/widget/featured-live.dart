import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/follow-bloc.dart';
import 'package:tienda/bloc/live-stream-bloc.dart';
import 'package:tienda/bloc/live-stream-product-bloc.dart';
import 'package:tienda/bloc/live-stream-product-details-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/model/live-video.dart';
import 'package:tienda/video-overlays/overlay_service.dart';
import 'package:tienda/view/live-stream/page/live-stream-screen.dart';
import 'package:tienda/view/login/login-main-page.dart';

class FeaturedLive extends StatelessWidget {
  final LiveVideo liveContent;

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
                        "${GlobalConfiguration().getString("imageURL")}/media/${liveContent.presenter.profilePicture}",
                      ),
                      fit: BoxFit.cover,
                    )),
                child: Container()),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 16),
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
                          child: Text(
                              "${DateTime.now().difference(liveContent.liveTime).toString().split('.').first.padLeft(8, "0")}",
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
                        Text(liveContent.programTitle,
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
                        Container(
                          width: MediaQuery.of(context).size.width - 120,
                          child: Text(liveContent.shortDescription,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: const Color(0xff1a1824),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "SFProDisplay",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 13.0),
                              textAlign: TextAlign.left),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                            "${liveContent.viewersCount} views • ${liveContent.commentCount} comments",
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
                          onPressed: () {
                            joinTheLiveSession(context, liveContent);
                          },
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

  void joinTheLiveSession(context, LiveVideo liveContent) {
    bool isGuestUser = BlocProvider.of<LoginBloc>(context).state is GuestUser;

    print("CHECK ISGUESTUSER: ${BlocProvider.of<LoginBloc>(context).state}");

    isGuestUser
        ? Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginMainPage()),
          )
        : OverlayService().addVideoTitleOverlay(
            context,
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (BuildContext context) =>
                      LiveStreamProductDetailsBloc(),
                ),
                BlocProvider(
                  create: (BuildContext context) => LiveStreamProductBloc(),
                ),
                BlocProvider(
                  create: (BuildContext context) => FollowBloc(),
                ),
                BlocProvider(create: (BuildContext context) => CheckOutBloc()),
                BlocProvider(create: (BuildContext context) => PresenterBloc()),
                BlocProvider(
                    create: (BuildContext context) => LiveStreamBloc()
                      ..add(JoinLive(liveContent.presenter.id))),
              ],
              child: LiveStreamScreen(liveContent.presenter),
            ),
            true,
            false);
  }
}
