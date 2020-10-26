import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tienda/bloc/bottom-nav-bar-bloc.dart';
import 'package:tienda/bloc/connectivity-bloc.dart';
import 'package:tienda/bloc/events/bottom-nav-bar-events.dart';
import 'package:tienda/bloc/events/live-events.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/live-contents-bloc.dart';
import 'package:tienda/bloc/live-stream-bloc.dart';
import 'package:tienda/bloc/states/bottom-nav-bar-states.dart';
import 'package:tienda/controller/one-signal-notification-controller.dart';
import 'package:tienda/view/cart/page/cart-page.dart';
import 'package:tienda/view/categories/categories-page.dart';
import 'package:tienda/view/customer-profile/profile-main-page.dart';
import 'package:tienda/view/home/page/home-screen.dart';
import 'package:tienda/view/live-stream/page/live-main-page.dart';
import 'package:tienda/view/live-stream/page/live-stream-screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  CategoriesPage categoryPage = CategoriesPage();
  HomeScreen homeScreenData = HomeScreen();
  CustomerProfile customerProfile = CustomerProfile();

  CartPage cartPage = new CartPage();
  LiveMainPage liveMainPage = new LiveMainPage();

  List<Widget> appflows;

  PageController pageController = new PageController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    initDynamicLinks();

    appflows = [
      BlocProvider(
        create: (context) =>
            LiveContentsBloc()..add(LoadCurrentLiveVideoList()),
        child: homeScreenData,
      ),
      categoryPage,
      BlocProvider(
        create: (context) => LiveContentsBloc()..add(LoadAllLiveStreamList()),
        child: liveMainPage,
      ),
      cartPage,
      customerProfile,
    ];

    BlocProvider.of<BottomNavBarBloc>(context)..add(Render());
    ConnectivityBloc()..initializeConnectivityListener();
    OneSignalNotificationController().initializeListeners();

    OneSignalNotificationController()
        .liveNotificationOpnStreamController
        .listen((value) {
      if (value != null) {
        Logger().d("PRESENTER ID CAPTURED: $value");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (BuildContext context) =>
                          LiveStreamBloc()..add(JoinLive(value.id)),
                      child: LiveStreamScreen(value),
                    )));
      }
    });
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      Logger().d("FIREBASE DYNAMIC INSTANCE RECEIVED");
      final Uri deepLink = dynamicLink?.link;

      //TODO:FIREBASE DYNAMIC LINK RE-DIRECTIONS
      if (deepLink != null) {
        if (deepLink.pathSegments[0] == 'referral') {
          Navigator.pushNamed(context, deepLink.pathSegments[0]);
        } else if (deepLink.pathSegments[0] == 'product') {
        } else if (deepLink.pathSegments[0] == 'review') {
        } else if (deepLink.pathSegments[0] == 'joinlive') {}
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }
  }

  DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          BlocProvider.of<BottomNavBarBloc>(context)
              .add(ChangeBottomNavBarState(0, false));
          currentBackPressTime = now;
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: BlocListener<BottomNavBarBloc, BottomNavBarStates>(
        listener: (context, state) {
          if (state is ChangeBottomNavBarStatusSuccess) {
            if (!state.hide && state.index != -1 || state.hide) {
              while (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            }

            pageController.jumpToPage(state.index);
          }
        },
        child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            resizeToAvoidBottomPadding: false,
            body: PageView(
              physics: new NeverScrollableScrollPhysics(),
              controller: pageController,
              children: appflows,
            )),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
