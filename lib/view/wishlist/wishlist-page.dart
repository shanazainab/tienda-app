import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';

import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/model/cart.dart';
import 'package:tienda/model/wishlist.dart';

import '../../localization.dart';

class WishListPage extends StatelessWidget {
  final WishList wishList;
  final BuildContext context;

  WishListPage(this.wishList, this.context);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: wishList.wishListItems.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio:  MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.4),
          crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return new Card(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: wishList.wishListItems[index].product.thumbnail,
                  width: MediaQuery.of(context).size.width / 2,
                  height: 180,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Color(0xfff2f2e4),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<WishListBloc>(context).add(
                            DeleteWishListItem(
                                wishList: wishList,
                                wishListItem: wishList.wishListItems[index]));
                      },
                      icon: Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ],
            ),
            ButtonTheme(
              height: 10,
              child: FlatButton(
                child: Center(
                    child: Text(
                  AppLocalizations.of(context).translate("add-to-cart"),
                  style: TextStyle(color: Colors.pink),
                )),
                onPressed: () {
                  print("PRODUCT CLICKED");
                  BlocProvider.of<CartBloc>(context).add(AddCartItem(
                      cartItem: new CartItem(
                          size: null,
                          quantity: 1,
                          product: wishList.wishListItems[index].product,
                          color: null)));

                  ///Moved to cart and delete from wish list
                  BlocProvider.of<WishListBloc>(context).add(
                      DeleteWishListItem(
                          wishList: wishList,
                          wishListItem: wishList.wishListItems[index]));
                },
              ),
            )
          ],
        ));
      },
    );
  }
}
