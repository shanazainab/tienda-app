import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:tienda/bloc/connectivity-bloc.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/live-stream-bloc.dart';
import 'package:tienda/controller/one-signal-notification-controller.dart';
import 'package:tienda/localization.dart';

import 'package:tienda/view/categories/categories-page.dart';
import 'package:tienda/view/home/home-bottom-app-bar.dart';
import 'package:tienda/view/home/tienda-home-page.dart';
import 'package:tienda/view/customer-profile/profile-main-page.dart';
import 'package:tienda/view/live-stream/shop-live-screen.dart';
import 'package:tienda/view/live-stream/live-stream-screen.dart';
import 'package:tienda/view/presenter-profile/profiles-view-main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  CategoriesPage categoryPage = CategoriesPage();
  TiendaHomePage tiendaHomePage = TiendaHomePage();
  CustomerProfile customerProfile = CustomerProfile();
  SellerProfileViewsMain sellerProfileViewsMain = new SellerProfileViewsMain();

  @override
  void initState() {
    // TODO: implement initState

    print("HOME BUILD");
    super.initState();
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
      _selectedIndex = index;
    });
  }

  DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) {

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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShopLiveScreen()),
            );
          },
          child: Icon(Icons.shop),
          elevation: 2.0,
        ),
        bottomNavigationBar: FABBottomAppBar(
          onTabSelected: _selectedTab,
          selectedColor: Colors.grey,
          centerItemText: AppLocalizations.of(context).translate('shop-live'),
          items: [
            FABBottomAppBarItem(
              iconData: FontAwesomeIcons.home,
              text: AppLocalizations.of(context).translate('home'),
            ),
            FABBottomAppBarItem(
                iconData: FontAwesomeIcons.layerGroup,
                text: AppLocalizations.of(context).translate('sellers')),
            FABBottomAppBarItem(
                iconData: FontAwesomeIcons.certificate,
                text: AppLocalizations.of(context).translate('category')),
            FABBottomAppBarItem(
                iconData: FontAwesomeIcons.user,
                text: AppLocalizations.of(context).translate('profile')),
          ],
        ),
        backgroundColor: Colors.white,
        body: IndexedStack(

          index: _selectedIndex,
          children: [
            tiendaHomePage,
            sellerProfileViewsMain,
            categoryPage,
            customerProfile
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
