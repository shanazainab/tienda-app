import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/view/checkout/checkout-orders-main-page.dart';

class CartCheckOutPopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartStates>(builder: (context, state) {
      if (state is LoadCartSuccess && state.cart != null)
        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: 3,
                    width: 80,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Cart",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      color: Colors.lightBlue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return BlocProvider(
                              create: (context) => CheckOutBloc(),
                              child: CheckoutOrdersMainPage(),
                            );
                          }),
                        );
                      },
                      child: Text(
                        "Checkout",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    shrinkWrap: true,
                    itemCount: state.cart.products.length,
                    itemBuilder: (BuildContext context, int index) => Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl: state
                                    .cart.products[index].thumbnail,
                                height: 90,
                                width: 80,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Container(
                                  color: Color(0xfff2f2e4),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(state
                                        .cart.products[index].brand),
                                    Text(
                                      state
                                          .cart.products[index].nameEn,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "Delete",
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "Move to Wishlist",
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                "AED ${state.cart.products[index].price}",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        )),
              )
            ],
          ),
        );
      else
        return Container();
    });
  }
}
