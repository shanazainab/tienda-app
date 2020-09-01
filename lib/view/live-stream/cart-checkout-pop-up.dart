import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/model/wishlist.dart';
import 'package:tienda/view/checkout/checkout-orders-main-page.dart';
import 'package:transparent_image/transparent_image.dart';

class CartCheckOutPopUp extends StatelessWidget {
  final BuildContext contextA;

  CartCheckOutPopUp(this.contextA);

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
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Colors.grey[200]
                                      ),
                                      bottom: BorderSide(
                                          color: Colors.grey[200]
                                      ),
                                      left: BorderSide(
                                          color: Colors.grey[200]
                                      ),
                                      top: BorderSide(
                                          color: Colors.grey[200]
                                      )
                                    )
                                  ),

                                  child: FadeInImage.memoryNetwork(
                                    image: state.cart.products[index].thumbnail,
                                    height: 120,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    placeholder: kTransparentImage,

                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 145,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(state.cart.products[index].brand),
                                      Text(
                                        state.cart.products[index].nameEn,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "AED ${state.cart.products[index].price}",
                                        style: TextStyle(fontWeight: FontWeight.w700),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: <Widget>[
                                            FlatButton(
                                              padding: EdgeInsets.all(0),
                                              onPressed: (){
                                                BlocProvider.of<CartBloc>(context).add(
                                                    DeleteCartItem(
                                                        cart: state.cart,
                                                        cartItem:
                                                        state.cart.products[index]));
                                              },
                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    decoration:
                                                        TextDecoration.underline,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            FlatButton(
                                              onPressed: (){
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
                                              child: Text(
                                                "Move to Wishlist",
                                                style: TextStyle(
                                                    decoration:
                                                        TextDecoration.underline,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                    )),
              )
            ],
          ),
        );
      else
        return Container(
          alignment: Alignment.center,
          child: Column(
            children: [
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
              Center(child: Padding(
                padding: const EdgeInsets.only(top:50.0),
                child: Text("Your Cart is Empty !!",style: TextStyle(
                  fontWeight: FontWeight.bold
                ),),
              )),
            ],
          ),
        );
    });
  }
}
