import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tienda/view/categories/categories-page.dart';
import 'package:tienda/view/home/home-bottom-app-bar.dart';
import 'package:tienda/view/home/tienda-home-page.dart';
import 'package:tienda/view/customer-profile/profile-menu.dart';
import 'package:tienda/view/seller-profile/seller-list-main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: _selectedIndex == 1
          ? AppBar(
              elevation: 0,
            )
          : PreferredSize(
              preferredSize: Size.fromHeight(50.0), // here the desired height

              child: HomePageAppbar()),*/
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.shop),
        elevation: 2.0,
      ),
      bottomNavigationBar: FABBottomAppBar(
        onTabSelected: _selectedTab,
        selectedColor: Colors.blue,
        centerItemText: "Shop Live",
        items: [
          FABBottomAppBarItem(
            iconData: FontAwesomeIcons.home,
            text: 'Home',
          ),
          FABBottomAppBarItem(
              iconData: FontAwesomeIcons.layerGroup, text: 'Category'),
          FABBottomAppBarItem(
              iconData: FontAwesomeIcons.certificate, text: 'Sellers'),
          FABBottomAppBarItem(iconData: FontAwesomeIcons.user, text: 'Profile'),
        ],
      ),
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          TiendaHomePage(),
          CategoriesPage(),
          SellerListMainPage(),
          CustomerProfile()
        ],
      ),
    );
  }
}
