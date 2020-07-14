import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/view/cart/cart-page.dart';
import 'package:tienda/view/notification/notification-screen.dart';
import 'package:tienda/view/search/search-page.dart';
import 'package:tienda/view/wishlist/wishlist-main-page.dart';
import 'package:tienda/view/wishlist/wishlist-page.dart';
import 'dart:io' show Platform;

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showCart;
  final bool showWishList;
  final bool showLogo;
  final bool showSearch;
  final bool showNotification;
  final Widget bottom;

  CustomAppBar(
      {this.title,
      this.showCart,
        this.showNotification,
      this.showWishList,
      this.showLogo,
      this.showSearch,
      this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(fontSize: 14),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
      bottom: bottom != null ? bottom : null,
      leading: showLogo
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Logo",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          : null,
      actions: <Widget>[
        if (showSearch)
          IconButton(
            constraints: BoxConstraints.tight(Size.square(40)),
            padding: EdgeInsets.all(0),
            visualDensity: VisualDensity.compact,
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
        if (showNotification != null && showNotification)
          IconButton(
            constraints: BoxConstraints.tight(Size.square(40)),
            padding: EdgeInsets.all(0),
            visualDensity: VisualDensity.compact,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
            icon: Icon(
              Icons.notifications_none,
              size: 20,
            ),
          ),
        if (showWishList)
          IconButton(
            visualDensity: VisualDensity.compact,
            constraints: BoxConstraints.tight(Size.square(40)),
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishListMainPage()),
              );
            },
            icon: Icon(
              Icons.bookmark,
              size: 20,
            ),
          ),
        if (showCart)
          IconButton(
              visualDensity: VisualDensity.compact,
              constraints: BoxConstraints.tight(Size.square(40)),
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
                  if (state.cart.cartItems.length != 0)
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
                  else
                    return Icon(
                      Icons.shopping_basket,
                      size: 20,
                    );
                } else
                  return Icon(
                    Icons.shopping_basket,
                    size: 20,
                  );
              })),
        SizedBox(
          width: 8,
        )
      ],
    );
  }
}
