import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/events/presenter-events.dart';
import 'package:tienda/bloc/follow-bloc.dart';
import 'package:tienda/bloc/live-contents-bloc.dart';
import 'package:tienda/bloc/live-stream-bloc.dart';
import 'package:tienda/bloc/live-stream-checkout-bloc.dart';
import 'package:tienda/bloc/live-stream-product-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/bloc/states/live-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/presenter-states.dart';
import 'package:tienda/model/live-contents.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';
import 'package:tienda/view/widgets/loading-widget.dart';
import 'package:tienda/video-overlays/overlay_service.dart';
import 'package:tienda/view/live-stream/live-stream-screen.dart';
import 'package:tienda/view/login/login-main-page.dart';
import 'package:tienda/view/presenter-profile/presenter-profile-page.dart';
import 'package:transparent_image/transparent_image.dart';

class ShopLiveScreen extends StatefulWidget {
  @override
  _ShopLiveScreenState createState() => _ShopLiveScreenState();
}

class _ShopLiveScreenState extends State<ShopLiveScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext contextA) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CustomAppBar(
            showSearch: true,
            showLogo: true,
            title: '',
            showCart: false,
            showNotification: false,
            showWishList: false,
            extend: false,
          ),
        ),
        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: BlocBuilder<LiveContentsBloc, LiveStates>(
              builder: (context, state) {
            if (state is LoadLiveVideoListSuccess &&
                state.liveContents.isNotEmpty) {
              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left:16,right:16,top:100),
                physics: ScrollPhysics(),
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0x29606170),
                              offset: Offset(0, 8),
                              blurRadius: 16,
                              spreadRadius: 0),
                          BoxShadow(
                              color: const Color(0x0a28293d),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                              spreadRadius: 0)
                        ],
                        color: const Color(0xffffffff)),
                    child: Container(
                      height: 250,
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                "${GlobalConfiguration().getString("mediaDevURL")}/${state.featuredLiveContent.thumbnail}",
                            height: 200,
                          ),
                          Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                            "${GlobalConfiguration().getString("mediaDevURL")}/${state.featuredLiveContent.presenter.profilePicture}",
                                          ),
                                        ),
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: new Border.all(
                                            color: Color(0xfff15223),
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'All About Hivebox Freezer',
                                            style: TextStyle(
                                              color: Color(0xfff15223),
                                              fontSize: 16,
                                              fontFamily: 'SFProDisplay',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            '16.6K subscribers',
                                            style: TextStyle(
                                              color: Color(0xff555555),
                                              fontSize: 12,
                                              fontFamily: 'SFProDisplay',
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      joinTheLiveSession(
                                          state.featuredLiveContent);
                                    },
                                    child: Container(
                                        width: 42,
                                        height: 42,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        decoration: new BoxDecoration(
                                            color: Color(0xfff15223),
                                            borderRadius:
                                                BorderRadius.circular(3))),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text("Today",
                      style: const TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                          fontSize: 13.0),
                      textAlign: TextAlign.left),
                  SizedBox(
                    height: 8,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.liveContents.length,
                    itemBuilder: (BuildContext context, int index) =>
                        GestureDetector(
                      onTap: () {
                        joinTheLiveSession(state.liveContents[index]);
                      },
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[

                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Container(
                                color: Colors.grey[200],
                                height: 100,
                                width: 150,
                                child: FadeInImage.memoryNetwork(
                                  fit: BoxFit.cover,
                                  placeholder: kTransparentImage,
                                  image:
                                      "${GlobalConfiguration().getString("mediaDevURL")}/${state.liveContents[index].thumbnail}",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    state.liveContents[index].presenter.name,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      state.liveContents[index].programTitle,
                                      softWrap: true,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is LoadLivePresenterSuccess) {
              return Container(
                child: Center(child: Text("NO LIVE")),
              );
            } else
              return spinKit;
          }),
        ));
  }

  void joinTheLiveSession(LiveContent liveContent) {
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
                  create: (BuildContext context) => LiveStreamCheckoutBloc(),
                ),
                BlocProvider(
                  create: (BuildContext context) => LiveStreamProductBloc(),
                ),
                BlocProvider(
                  create: (BuildContext context) => FollowBloc(),
                ),
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
