import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/connectivity-bloc.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/live-stream-bloc.dart';
import 'package:tienda/bloc/live-stream-checkout-bloc.dart';
import 'package:tienda/bloc/live-stream-product-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/controller/one-signal-notification-controller.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/video-overlays/overlay_service.dart';
import 'package:tienda/view/categories/categories-page.dart';
import 'package:tienda/view/checkout/checkout-orders-main-page.dart';
import 'package:tienda/view/home/tienda-home-page.dart';
import 'package:tienda/view/customer-profile/profile-main-page.dart';
import 'package:tienda/view/live-stream/live-stream-new-design.dart';
import 'package:tienda/view/live-stream/shop-live-screen.dart';
import 'package:tienda/view/live-stream/live-stream-screen.dart';
import 'package:tienda/view/presenter-profile/profiles-view-main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  int _currentBarIndex = 0;

  PageController pageController = new PageController();

  CategoriesPage categoryPage = CategoriesPage();
  HomeScreenData homeScreenData = HomeScreenData();
  CustomerProfile customerProfile = CustomerProfile();
  SellerProfileViewsMain sellerProfileViewsMain = new SellerProfileViewsMain();

  ShopLiveScreen shopLiveScreen = new ShopLiveScreen();

  List<Widget> appflows;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    appflows = [
      Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (settings) => MaterialPageRoute(
          settings: settings,
          builder: (context) => homeScreenData,
        ),
      ),
      Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (settings) => MaterialPageRoute(
          settings: settings,
          builder: (context) => sellerProfileViewsMain,
        ),
      ),
      Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (settings) => MaterialPageRoute(
            settings: settings, builder: (context) => shopLiveScreen),
      ),
      Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (settings) => MaterialPageRoute(
            settings: settings,
            builder: (context) => BlocProvider(
                  create: (context) => CheckOutBloc(),
                  child: CheckoutOrdersMainPage(),
                )),
      ),
      Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (settings) => MaterialPageRoute(
          settings: settings,
          builder: (context) => customerProfile,
        ),
      ),
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

  void _selectedTab(int index) {
    setState(() {
      _currentBarIndex = index;
    });

    pageController.jumpToPage(_currentBarIndex);
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _currentBarIndex = 2;
                });
                pageController.jumpToPage(2);
              },

              mini: true,
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
              elevation: 2.0,
              backgroundColor: Color(0xFFff2e63),

              ///#ff2e63
            ),
          ),
          bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 16.0, right: 16),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  child: Container(
                    height: 44,
                    child: BottomNavigationBar(
                      onTap: _selectedTab,
                      type: BottomNavigationBarType.fixed,
                      currentIndex: _currentBarIndex,
                      elevation: 8,
                      selectedLabelStyle: TextStyle(fontSize: 0),
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      unselectedFontSize: 0,
                      selectedItemColor: Color(0xFFff2e63),
                      unselectedItemColor: Colors.black,
                      iconSize: 20,
                      items: [
                        BottomNavigationBarItem(
                            icon: SvgPicture.asset(
                              "assets/svg/home.svg",
                              color: _currentBarIndex == 0
                                  ? Color(0xFFff2e63)
                                  : Colors.black,
                            ),
                            title: Text('Personal')),
                        BottomNavigationBarItem(
                            icon: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: SvgPicture.asset(
                                "assets/svg/category.svg",
                                // color: _currentBarIndex == 1? Color(0xFFff2e63): Colors.black,
                              ),
                            ),
                            title: Text('Personal')),
                        BottomNavigationBarItem(
                            icon: Container(
                              height: 0,
                            ),
                            title: Text('Personal')),
                        BottomNavigationBarItem(
                            icon: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    "assets/svg/cart.svg",
                                    color: _currentBarIndex == 3
                                        ? Color(0xFFff2e63)
                                        : Colors.black,
                                  ),
                                ),
                                BlocBuilder<CartBloc, CartStates>(
                                    builder: (context, state) {
                                  if (state is AddToCartSuccess) {
                                    return Positioned(
                                        bottom: 12,
                                        left: 35,
                                        child: Text(
                                          state.addedCart.products.length
                                              .toString(),
                                          style: TextStyle(fontSize: 12),
                                        ));
                                  } else if (state is LoadCartSuccess) {
                                    if (state.cart != null)
                                      return Positioned(
                                          bottom: 12,
                                          left: 35,
                                          child: Text(
                                            state.cart.products.length
                                                .toString(),
                                            style: TextStyle(fontSize: 12),
                                          ));
                                    else
                                      return Positioned(
                                          bottom: 12,
                                          left: 35,
                                          child: Text(
                                            "0",
                                            style: TextStyle(fontSize: 12),
                                          ));
                                  } else
                                    return Positioned(
                                        bottom: 12,
                                        left: 35,
                                        child: Text(
                                          "0",
                                          style: TextStyle(fontSize: 12),
                                        ));
                                }),
                              ],
                            ),
                            title: Text('Personal')),
                        BottomNavigationBarItem(
                            icon: BlocBuilder<LoginBloc, LoginStates>(
                                builder: (context, state) {
                              if (state is LoggedInUser)
                                return BlocBuilder<CustomerProfileBloc,
                                        CustomerProfileStates>(
                                    builder: (context, state) {
                                  if (state is LoadCustomerProfileSuccess)
                                    return CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Color(0xfff2f2e4),
                                        backgroundImage: CachedNetworkImageProvider(
                                            "${GlobalConfiguration().getString("imageURL")}/${state.customerDetails.profilePicture}"));

                                  if (state is NoCustomerData)
                                    return CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Color(0xfff2f2e4),
                                        backgroundImage: AssetImage(
                                            "assets/images/profile-placeholder.png"));
                                  if (state is OfflineLoadCustomerDataSuccess)
                                    return CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Color(0xfff2f2e4),
                                        backgroundImage: CachedNetworkImageProvider(
                                            "${GlobalConfiguration().getString("imageURL")}/${state.customerDetails.profilePicture}"));
                                  else
                                    return CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Color(0xfff2f2e4),
                                        backgroundImage: AssetImage(
                                            "assets/images/profile-placeholder.png"));
                                });
                              else
                                return CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Color(0xfff2f2e4),
                                    backgroundImage: AssetImage(
                                        "assets/images/profile-placeholder.png"));
                            }),
                            title: Text('Personal'))
                      ],
                    ),
                  ),
                ),
              )),
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
