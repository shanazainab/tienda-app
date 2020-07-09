import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tienda/localization.dart';

import 'package:tienda/view/categories/categories-page.dart';
import 'package:tienda/view/home/home-bottom-app-bar.dart';
import 'package:tienda/view/home/tienda-home-page.dart';
import 'package:tienda/view/customer-profile/profile-menu.dart';
import 'package:tienda/view/live-stream/shop-live-screen.dart';
import 'package:tienda/view/seller-profile/profiles-view-main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  CategoriesPage categoryPage = CategoriesPage();
  TiendaHomePage tiendaHomePage = TiendaHomePage();
  SellerProfileViewsMain sellerProfileViewsMain = SellerProfileViewsMain();

  CustomerProfile customerProfile = CustomerProfile();

  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        selectedColor: Colors.blue,
        centerItemText: AppLocalizations.of(context).translate('shop-live'),
        items: [
          FABBottomAppBarItem(
            iconData: FontAwesomeIcons.home,
            text: AppLocalizations.of(context).translate('home'),
          ),
          FABBottomAppBarItem(
              iconData: FontAwesomeIcons.layerGroup,
              text: AppLocalizations.of(context).translate('category')),
          FABBottomAppBarItem(
              iconData: FontAwesomeIcons.certificate,
              text: AppLocalizations.of(context).translate('sellers')),
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
          categoryPage,
          sellerProfileViewsMain,
          customerProfile
        ],
      ),
    );
  }
}
