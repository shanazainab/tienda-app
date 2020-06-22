import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/wishlist-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/model/cart.dart';
import 'package:tienda/view/cart/cart-page.dart';

class WishListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: <Widget>[
            IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                },
                icon: BlocBuilder<CartBloc, CartStates>(
                    builder: (context, state) {
                  if (state is AddToCartSuccess) {
                    return Badge(
                      toAnimate: true,
                      borderRadius: 2,
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
                      toAnimate: true,
                      borderRadius: 2,
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
        body: BlocBuilder<WishListBloc, WishListStates>(
            bloc: BlocProvider.of<WishListBloc>(context)
              ..add(LoadWishListProducts()),
            builder: (context, state) {
              if (state is LoadWishListSuccess) {
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: state.wishList.wishListItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio:
                          MediaQuery.of(context).size.height / 945,
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return new Card(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                BlocProvider.of<WishListBloc>(context).add(
                                    DeleteWishListItem(
                                        wishListItem: state
                                            .wishList.wishListItems[index]));
                              },
                              icon: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                        CachedNetworkImage(
                          imageUrl: state
                              .wishList.wishListItems[index].product.thumbnail,
                          width: MediaQuery.of(context).size.width / 2,
                          height: 180,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Color(0xfff2f2e4),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        ButtonTheme(
                          height: 10,
                          child: FlatButton(
                            child: Center(
                                child: Text(
                              "MOVE TO BAG",
                              style: TextStyle(color: Colors.pink),
                            )),
                            onPressed: () {
                              print("PRODUCT CLICKED");
                              BlocProvider.of<CartBloc>(context).add(
                                  AddCartItem(
                                      cartItem: new CartItem(
                                          size: null,
                                          quantity: 1,
                                          product: state.wishList
                                              .wishListItems[index].product,
                                          color: null)));
                            },
                          ),
                        )
                      ],
                    ));
                  },
                );
              } else {
                return Container(
                  child: Center(child: Text("No products in WishList")),
                );
              }
            }));
  }
}
