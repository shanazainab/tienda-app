import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/connectivity-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/main.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/model/wishlist.dart';
import 'package:tienda/view/login/login-main-page.dart';
import 'package:transparent_image/transparent_image.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return BlocBuilder<CartBloc, CartStates>(
      builder: (context, state) {
        if (state is LoadCartSuccess && state.cart != null)
          return Stack(
            children: <Widget>[
              Container(
                child: ListView(
                  padding: EdgeInsets.only(bottom: 100,left: 16,right:16),
                  children: <Widget>[

                    Text(AppLocalizations.of(context).translate("shopping-bag"),style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),),

                    SizedBox(
                      height: 30,
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.cart.products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Container(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FadeInImage.memoryNetwork(


                                  image:
                                      state.cart.products[index].thumbnail,
                                  width: 100,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  placeholder: kTransparentImage,

                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:16.0,right:16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        state.cart.products[index].brand != null
                                            ? Text(
                                                state
                                                    .cart.products[index].brand,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : Container(),
                                        Text(
                                          appLanguage.appLocal == Locale('en')
                                              ? state
                                                  .cart.products[index].nameEn
                                              : state
                                                  .cart.products[index].nameAr,
                                          softWrap: true,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            '${AppLocalizations.of(context).translate('aed')} ${state.cart.products[index].price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                if (state.cart.products[index]
                                                        .quantity ==
                                                    1) {
                                                  ///delete the item
                                                  ///or don do anything
                                                } else {

                                                  state.cart.products[index]
                                                      .quantity = state
                                                          .cart
                                                          .products[index]
                                                          .quantity -
                                                      1;
                                                  BlocProvider.of<CartBloc>(
                                                      context)
                                                    ..add(EditCartItem(
                                                        cart: state.cart,
                                                        editType:
                                                            "QUANTITY EDIT",
                                                        cartItem: state.cart
                                                            .products[index]));
                                                }
                                              },
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                color: Colors.black,
                                                size: 16,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8),
                                              child: Text(state
                                                  .cart.products[index].quantity
                                                  .toString(),style: TextStyle(
                                                fontSize: 16
                                              ),),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                state.cart.products[index]
                                                    .quantity = state
                                                        .cart
                                                        .products[index]
                                                        .quantity +
                                                    1;

                                                BlocProvider.of<CartBloc>(
                                                    context)
                                                  ..add(EditCartItem(
                                                      cart: state.cart,
                                                      editType: "QUANTITY EDIT",
                                                      cartItem: state.cart
                                                          .products[index]));
                                              },
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.black,
                                                size: 16,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    BlocProvider.of<CartBloc>(context).add(
                                        DeleteCartItem(
                                            cart: state.cart,
                                            cartItem:
                                                state.cart.products[index]));
                                  },
                                  child: Center(
                                      child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.delete,
                                        size: 14,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('remove'),
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
                                      product: state.cart.products[index],
                                    )));

                                    BlocProvider.of<CartBloc>(context).add(
                                        DeleteCartItem(
                                            cart: state.cart,
                                            cartItem:
                                                state.cart.products[index]));
                                  },
                                  child: Center(
                                      child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.bookmark,
                                        size: 14,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('move-to-wishlist')
                                            .toUpperCase(),
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
                    ),
                   // if (state.cart != null) priceContainer(state.cart.cartPrice)
                  ],
                ),
              ),
              if (state.cart != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    margin: EdgeInsets.all(0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "TOTAL: ${AppLocalizations.of(context).translate('aed')} ${(state.cart.cartPrice - 0).toStringAsFixed(2)}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 50,
                              child: RaisedButton(
                                onPressed: () {
                                  BlocProvider.of<LoginBloc>(context).state
                                          is GuestUser
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginMainPage()),
                                        )
                                      : BlocProvider.of<CheckOutBloc>(context).add(
                                          DoUpdateCheckOutProgress(
                                              order: new Order(),
                                              status: "ADDRESS"));
                                },
                                child: Text(AppLocalizations.of(context)
                                    .translate('checkout')),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        else
          return Container(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_basket,
                    size: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Text(
                      "Your Cart is Empty",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
      },
    );
  }

  priceContainer(double cartPrice) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Text(
              AppLocalizations.of(context).translate('price-details'),
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('cart-total'),
                ),
                Text(
                    "${AppLocalizations.of(context).translate('aed')} ${cartPrice}"),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('cart-discount'),
                ),
                Text("${AppLocalizations.of(context).translate('aed')} ${0}"),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('order-total'),
                ),
                Text(
                    "${AppLocalizations.of(context).translate('aed')} ${cartPrice}"),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('delivery-charge'),
                ),
                Text(
                  AppLocalizations.of(context).translate('free'),
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Divider(),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('total'),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                    "${AppLocalizations.of(context).translate('aed')} ${cartPrice}",
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void checkConnectivity() {
    ConnectivityBloc().connectivityStream.listen((value) {
      if (value == ConnectivityResult.none) {
        BlocProvider.of<CartBloc>(context).add(OfflineLoadCart());
      }
    });
  }
}
