import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/wishlist.dart';
import 'dart:io' show Platform;

import 'package:tienda/view/home/home-page.dart';
import 'package:tienda/view/checkout/checkout-orders-main-page.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _selectedCartItem = BehaviorSubject<int>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return Future.value(false);
      },
      child: BlocProvider.value(
          value: BlocProvider.of<CartBloc>(context)..add(FetchCartData()),
          //  create: (BuildContext context) => CartBloc()..add(),
          child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(44),
                  child: CustomAppBar(
                    showLogo: false,
                    showCart: true,
                    showSearch: true,
                    showWishList: true,
                    title: AppLocalizations.of(context).translate("cart"),
                  )),
              bottomNavigationBar: ButtonTheme(
                height: 48,
                minWidth: MediaQuery.of(context).size.width - 48,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(05)),
                child: RaisedButton(
                  onPressed: () {
                    handleCheckOut();
                  },
                  child: Text("CHECKOUT"),
                ),
              ),
              body:
                  BlocBuilder<CartBloc, CartStates>(builder: (context, state) {
                if (state is LoadCartSuccess)
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.cart.cartItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Card(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl: state
                                    .cart.cartItems[index].product.thumbnail,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Color(0xfff2f2e4),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Brand",
                                      softWrap: true,
                                    ),
                                    Text(
                                      state.cart.cartItems[index].product
                                          .nameEn
                                          .substring(0, 9),
                                      softWrap: true,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'AED ${state.cart.cartItems[index].product.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                        width: 120,
                                        child: Row(
                                          children: <Widget>[
                                            ButtonTheme(
                                              height: 10,
                                              minWidth: 10,
                                              child: RaisedButton(
                                                  color: Colors.grey[200],
                                                  onPressed: () {
                                                    if (state
                                                            .cart
                                                            .cartItems[index]
                                                            .quantity ==
                                                        1) {
                                                      ///delete the item
                                                      ///or don do anything
                                                    } else {}
                                                  },
                                                  child: Text("-")),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8),
                                              child: Text(state.cart
                                                  .cartItems[index].quantity
                                                  .toString()),
                                            ),
                                            ButtonTheme(
                                              height: 10,
                                              minWidth: 10,
                                              child: RaisedButton(
                                                  color: Colors.grey[200],
                                                  onPressed: () {
                                                    state.cart.cartItems[index]
                                                        .quantity = state
                                                            .cart
                                                            .cartItems[index]
                                                            .quantity +
                                                        1;
                                                  },
                                                  child: Text('+')),
                                            )
                                          ],
                                        )),
                                    GestureDetector(
                                      onTap: () {
                                        if (_selectedCartItem.value != index)
                                          _selectedCartItem.add(index);
                                        else
                                          _selectedCartItem.add(null);
                                      },
                                      child: Container(
                                        color: Colors.grey[200],
                                        child: Row(
                                          children: <Widget>[
                                            Text("Size:"),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8),
                                              child: Text("ONESIZE"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    StreamBuilder<int>(
                                        stream: _selectedCartItem,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<int> snapshot) {
                                          if (snapshot.data != null &&
                                              snapshot.data == index) {
                                            return Container(
                                              height: 30,
                                              child: ListView.builder(
                                                  itemCount: 4,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder: (BuildContext
                                                              context,
                                                          int index) =>
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 4.0),
                                                          child: Container(
                                                            width: 40,
                                                            height: 40,
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text("L"),
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ))),
                                            );
                                          } else
                                            return Container();
                                        }),
                                  ],
                                ),
                              )
                            ],
                          ),
//                          Divider(
//                            endIndent: 16,
//                            indent: 16,
//                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  BlocProvider.of<CartBloc>(context).add(
                                      DeleteCartItem(
                                          cartItem:
                                              state.cart.cartItems[index]));
                                },
                                child: Center(
                                    child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.delete,
                                      size: 14,
                                    ),
                                    Text(
                                      "REMOVE",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                )),
                              ),
                              Container(
                                height: 25,
                                color: Colors.grey[200],
                                width: 1,
                              ),
                              FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  BlocProvider.of<WishListBloc>(context)
                                      .add(AddToWishList(
                                          wishListItem: new WishListItem(
                                    product:
                                        state.cart.cartItems[index].product,
                                  )));

                                  BlocProvider.of<CartBloc>(context).add(
                                      DeleteCartItem(
                                          cartItem:
                                              state.cart.cartItems[index]));
                                },
                                child: Center(
                                    child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.bookmark,
                                      size: 14,
                                    ),
                                    Text(
                                      "MOVE TO WISHLIST",
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ],
                          ),
                        ],
                      ));
                    },
                  );
                else
                  return Container();
              }))),
    );
  }

  void handleCheckOut() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CheckoutOrdersMainPage()),
    );
  }
}
