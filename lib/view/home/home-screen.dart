import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/connectivity-bloc.dart';
import 'package:tienda/bloc/events/live-events.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/live-contents-bloc.dart';
import 'package:tienda/bloc/live-stream-bloc.dart';
import 'package:tienda/bloc/startup-bloc.dart';
import 'package:tienda/controller/one-signal-notification-controller.dart';
import 'package:tienda/view/categories/categories-page.dart';
import 'package:tienda/view/checkout/checkout-orders-main-page.dart';
import 'package:tienda/view/customer-profile/profile-main-page.dart';
import 'package:tienda/view/home/home-screen-data.dart';
import 'package:tienda/view/live-stream/live-stream-screen.dart';
import 'package:tienda/view/live-stream/shop-live-screen.dart';

PageController pageController = new PageController();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  int _currentBarIndex = 0;

  CategoriesPage categoryPage = CategoriesPage();
  HomeScreenData homeScreenData = HomeScreenData();
  CustomerProfile customerProfile = CustomerProfile();

  ShopLiveScreen shopLiveScreen = new ShopLiveScreen();

  List<Widget> appflows;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    appflows = [
      BlocProvider(
        create: (context) => LiveContentsBloc()..add(LoadLiveVideoList()),
        child: homeScreenData,
      ),
      categoryPage,
      BlocProvider(
        create: (context) => LiveContentsBloc()..add(LoadLiveVideoList()),
        child: shopLiveScreen,
      ),
      BlocProvider(
        create: (context) => CheckOutBloc(),
        child: CheckoutOrdersMainPage(),
      ),
      customerProfile,
    ];

    ConnectivityBloc()..initializeConnectivityListener();
    OneSignalNotificationController().initializeListeners();

    OneSignalNotificationController().liveNotOpenedStream.listen((value) {
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

  DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(
              msg: 'Tap back again to exit', gravity: ToastGravity.BOTTOM);
          return Future.value(false);
        }
        return Future.value(true);
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
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}
