import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/loading-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/cart.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/view/cart/cart-items-container.dart';
import 'package:tienda/view/live-stream/cart-checkout-pop-up.dart';
import 'package:tienda/view/login/login-main-page.dart';

class LiveStreamCartContainer extends StatelessWidget {
  final Cart cart;
  final CartCheckOutPopVisibility cartCheckOutPopVisibility;

  final RealTimeController realTimeController = new RealTimeController();

  final Order order;
  LiveStreamCartContainer(this.cart,this.cartCheckOutPopVisibility,this.order);

  @override
  Widget build(BuildContext context) {
    return cart != null?

       Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        cartCheckOutPopVisibility(true);
                      },
                    )
                  ],
                ),
                Text(
                  AppLocalizations.of(context)
                      .translate("shopping-bag"),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 16,
                ),

                Expanded(
                    child: CartItemsContainer(cart)),
                // if (state.cart != null) priceContainer(state.cart.cartPrice)
              ],
            ),
          ),
          if (cart != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                margin: EdgeInsets.all(0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: <Widget>[

                      Padding(
                        padding:
                        const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "TOTAL: ${AppLocalizations.of(context).translate('aed')} ${(cart.cartPrice - 0).toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                            width: MediaQuery.of(context)
                                .size
                                .width -
                                50,
                            child: BlocBuilder<LoadingBloc,
                                LoadingStates>(
                                builder:
                                    (context, loadingState) {
                                  if (loadingState is NotLoading) {
                                    return RaisedButton(
                                      onPressed: () {
                                        print(
                                            "ADDRESS CART STATES: ${cart.products}");
                                        BlocProvider.of<LoginBloc>(
                                            context)
                                            .state is GuestUser
                                            ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                  LoginMainPage()),
                                        )
                                            : BlocProvider.of<
                                            CheckOutBloc>(
                                            context)
                                            .add(DoUpdateCheckOutProgress(
                                            order: order,
                                            status:
                                            "ADDRESS"));
                                      },
                                      child: Text(AppLocalizations
                                          .of(context)
                                          .translate('checkout')),
                                    );
                                  } else
                                    return RaisedButton(
                                      onPressed: () {},
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child:
                                        CircularProgressIndicator(
                                          backgroundColor:
                                          Colors.white,
                                          strokeWidth: 1,
                                        ),
                                      ),
                                    );
                                })),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ):
   Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_basket,
                size: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Your Cart is Empty",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
