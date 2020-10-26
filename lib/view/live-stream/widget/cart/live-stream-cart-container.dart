import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/cart/widget/cart-items-container.dart';
import 'package:tienda/view/live-stream/widget/cart/cart-price-and-checkout.dart';
typedef OnCartClose = Function();
typedef OnProceedToCheckout = Function();
class LiveStreamCartContainer extends StatelessWidget {
  final OnCartClose onCartClose;
  final OnProceedToCheckout onProceedToCheckout;
  LiveStreamCartContainer({this.onCartClose,this.onProceedToCheckout});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartStates>(
        builder: (context, cartState) {
          if (cartState is LoadCartSuccess)
            return Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${AppLocalizations.of(context).translate(
                                "shopping-bag")} (${cartState.cart.products.length})",
                            style: TextStyle(
                              color: Color(0xff282828),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {

                              onCartClose();
                            },
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 16,
                    ),

                    Expanded(child: CartItemsContainer(cartState.cart)),
                    // if (state.cart != null) priceContainer(state.cart.cartPrice)
                  ],
                ),
                if (cartState.cart != null)
                  Align(
                      alignment: Alignment.bottomCenter,
                      child:  CartPriceAndCheckout(cartState.cart ,(){
                        onProceedToCheckout();
                      })),
              ],
            );
          else
            return Container();
        });
  }
}
