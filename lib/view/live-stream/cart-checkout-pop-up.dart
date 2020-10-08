import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/events/loading-events.dart';
import 'package:tienda/bloc/events/saved-card-events.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/saved-card-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/checkout-states.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/view/live-stream/live-stream-cart-container.dart';
import 'package:tienda/view/live-stream/payment-container.dart';

import 'choose-delivery-address.dart';

typedef CheckOutStatus = Function(bool done);
typedef CartCheckOutPopVisibility = Function(bool shouldClose);

final PageController pageController = new PageController(
  initialPage: 0,
);

class CartCheckOutPopUp extends StatelessWidget {
  final BuildContext contextA;

  final RealTimeController realTimeController = new RealTimeController();

  final CheckOutStatus checkOutStatus;

  final CartCheckOutPopVisibility cartCheckOutPopVisibility;

  final int presenterId;

  CartCheckOutPopUp(this.contextA, this.checkOutStatus,
      this.cartCheckOutPopVisibility, this.presenterId);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<CartBloc, CartStates>(
            listener: (contextA, state) {
              if (state is LoadCartSuccess && state.cart != null) {
                print("CART BLOC LOAD SUCCESS");
                BlocProvider.of<CheckOutBloc>(contextA).add(
                    DoUpdateCheckOutProgress(
                        status: "CART",
                        order: new Order(products: state.cart.products)));
              }
            },
          ),
          BlocListener<CheckOutBloc, CheckoutStates>(
            listener: (contextA, state) {
              if (state is AddressActive) {
                pageController.animateToPage(1,
                    duration: Duration(
                      milliseconds: 500,
                    ),
                    curve: Curves.easeIn);
              }
              if (state is PaymentActive)
                pageController.animateToPage(2,
                    duration: Duration(
                      milliseconds: 500,
                    ),
                    curve: Curves.easeIn);
              if (state is CartActive)
                pageController.animateToPage(0,
                    duration: Duration(
                      milliseconds: 500,
                    ),
                    curve: Curves.easeIn);

              if (state is InitialCheckOutSuccess) {
                ///Empty the cart
                BlocProvider.of<CartBloc>(contextA).add(ClearCart());
                BlocProvider.of<LoadingBloc>(context)..add(StopLoading());

                pageController.animateToPage(3,
                    duration: Duration(
                      milliseconds: 500,
                    ),
                    curve: Curves.easeIn);
              }
            },
          )
        ],
        child: BlocBuilder<CheckOutBloc, CheckoutStates>(
            builder: (contextA, checkoutState) {
          return Container(
            color: Colors.white,
            child: PageView(
              physics: new NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: pageController,
              children: <Widget>[
                ///cart
                if (checkoutState is CartActive)
                  BlocBuilder<CartBloc, CartStates>(
                    builder: (context, cartState) {
                      if (cartState is LoadCartSuccess)
                        return LiveStreamCartContainer(cartState.cart,
                            cartCheckOutPopVisibility, checkoutState.order);
                      else {
                        return LiveStreamCartContainer(null,
                            cartCheckOutPopVisibility, checkoutState.order);
                      }
                    },
                  ),

                ///delivery address
                if (checkoutState is AddressActive)
                  BlocProvider<AddressBloc>(
                      create: (BuildContext context) =>
                          AddressBloc()..add(LoadSavedAddress()),
                      child: ChooseDeliveryAddress(
                          cartCheckOutPopVisibility, checkoutState.order)),

                ///payment
                if (checkoutState is PaymentActive)
                  BlocProvider<SavedCardBloc>(
                      create: (BuildContext context) =>
                          SavedCardBloc()..add(LoadSavedCards()),
                      child: LiveStreamPaymentContainer(
                          cartCheckOutPopVisibility,
                          presenterId,
                          checkoutState.order)),

                ///order success page
                if (checkoutState is InitialCheckOutSuccess)
                  Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('ORDER SUCCESS'),
                        RaisedButton(
                          onPressed: () {
                            checkOutStatus(true);
                          },
                          child: Text("Continue Watching"),
                        )
                      ],
                    )),
                  ),
              ],
            ),
          );
        }));
  }
}
