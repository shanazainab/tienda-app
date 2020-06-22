import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/view/cart/cart-page.dart';
import 'package:tienda/view/home/fab-bottom-app-bar.dart';
import 'package:tienda/view/home/home-page.dart';
import 'package:tienda/view/home/test-page.dart';
import 'package:tienda/view/products/product-list-page.dart';
import 'package:tienda/view/profile/customer-profile.dart';
import 'package:tienda/view/search/search-page.dart';
import 'package:tienda/view/wishlist/wishlist-page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Logo",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            icon: Icon(
              Icons.search,
              size: 20,
            ),
          ),
          IconButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishListPage()),
              );
            },
            icon: Icon(
              Icons.bookmark,
              size: 20,
            ),
          ),
          IconButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
              icon:
                  BlocBuilder<CartBloc, CartStates>(builder: (context, state) {
                if (state is AddToCartSuccess) {
                  return Badge(
                    badgeContent: Text(
                      state.addedCart.cartItems.length.toString(),
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    child: Icon(
                      Icons.shopping_basket,
                      size: 20,
                    ),
                  );
                } else if (state is LoadCartSuccess) {
                  return Badge(
                    badgeContent: Text(
                      state.cart.cartItems.length.toString(),
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    child: Icon(
                      Icons.shopping_basket,
                      size: 20,
                    ),
                  );
                } else
                  return Icon(
                    Icons.shopping_basket,
                    size: 20,
                  );
              }))
        ],
      ),
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
          HomePage(),
          ProductListPage(),
          TestPage(),
          CustomerProfile()
        ],
      ),
    );
  }
}
