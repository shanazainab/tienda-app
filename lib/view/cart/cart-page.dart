import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/model/wishlist.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<CartBloc>(context)..add(FetchCartData()),
        //  create: (BuildContext context) => CartBloc()..add(),
        child: Scaffold(
            appBar: AppBar(
              title: Text("Cart"),
            ),
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
            body: BlocBuilder<CartBloc, CartStates>(builder: (context, state) {
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
                              imageUrl:
                                  state.cart.cartItems[index].product.thumbnail,
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
                                    state.cart.cartItems[index].product
                                        .nameEnglish
                                        .substring(0, 9),
                                    softWrap: true,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(state
                                        .cart.cartItems[index].product.price
                                        .toStringAsFixed(2)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Divider(
                          endIndent: 16,
                          indent: 16,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                BlocProvider.of<CartBloc>(context).add(
                                    DeleteCartItem(
                                        cartItem: state.cart.cartItems[index]));
                              },
                              child: Center(child: Text("REMOVE")),
                            ),
                            FlatButton(
                              onPressed: () {
                                BlocProvider.of<WishListBloc>(context)
                                    .add(AddToWishList(
                                        wishListItem: new WishListItem(
                                  product: state.cart.cartItems[index].product,
                                )));

                                BlocProvider.of<CartBloc>(context).add(
                                    DeleteCartItem(
                                        cartItem: state.cart.cartItems[index]));
                              },
                              child: Center(child: Text("MOVE TO WISHLIST")),
                            ),
                          ],
                        ),
                      ],
                    ));
                  },
                );
              else
                return Container();
            })));
  }

  void handleCheckOut() {}
}
