import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/view/cart/cart-page.dart';
import 'package:tienda/view/search/search-page.dart';
import 'package:tienda/view/wishlist/wishlist-page.dart';

class HomeTopAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
            icon: BlocBuilder<CartBloc, CartStates>(builder: (context, state) {
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
    );
  }
}
