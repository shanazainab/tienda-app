import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/events/saved-card-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/saved-card-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/checkout-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/view/cart/cart-items-container.dart';
import 'package:tienda/view/checkout/payment-container.dart';
import 'package:tienda/view/live-stream/payment-container.dart';
import 'package:tienda/view/login/login-main-page.dart';

import '../../localization.dart';
import 'choose-delivery-address.dart';

typedef CheckOutStatus = Function(bool done);
typedef CartCheckOutPopVisibility = Function(bool shouldClose);
final PageController pageController = new PageController(
  initialPage: 0,
);
class CartCheckOutPopUp extends StatelessWidget {
  final BuildContext contextA;

  final CheckOutStatus checkOutStatus;

  final CartCheckOutPopVisibility cartCheckOutPopVisibility;

  CartCheckOutPopUp(this.contextA, this.checkOutStatus,this.cartCheckOutPopVisibility);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<CartBloc, CartStates>(
            listener: (contextA, state) {
              if (state is LoadCartSuccess && state.cart != null)
                BlocProvider.of<CheckOutBloc>(contextA).add(
                    DoUpdateCheckOutProgress(
                        order: new Order(), status: "CART"));
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
            builder: (contextA, state) {
          return Container(
            color: Colors.white,
            child: PageView(
              physics: new NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: pageController,
              children: <Widget>[
                BlocBuilder<CartBloc, CartStates>(
                  builder: (context, state) {
                    if (state is LoadCartSuccess && state.cart != null)
                      return Stack(
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
                                    onPressed: (){
                                      cartCheckOutPopVisibility(true);
                                    },
                                  )
                                ],),
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

                                Expanded(child: CartItemsContainer(state.cart)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "TOTAL: ${AppLocalizations.of(context).translate('aed')} ${(state.cart.cartPrice - 0).toStringAsFixed(2)}",
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
                                          child: RaisedButton(
                                            onPressed: () {
                                              BlocProvider.of<LoginBloc>(
                                                          context)
                                                      .state is GuestUser
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginMainPage()),
                                                    )
                                                  : BlocProvider.of<
                                                          CheckOutBloc>(context)
                                                      .add(
                                                          DoUpdateCheckOutProgress(
                                                              order:
                                                                  new Order(),
                                                              status:
                                                                  "ADDRESS"));
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)
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
                  },
                ),
                BlocProvider<AddressBloc>(
                    create: (BuildContext context) =>
                        AddressBloc()..add(LoadSavedAddress()),
                    child: ChooseDeliveryAddress(cartCheckOutPopVisibility)),
                BlocProvider<SavedCardBloc>(
                    create: (BuildContext context) =>
                        SavedCardBloc()..add(LoadSavedCards()),
                    child: LiveStreamPaymentContainer(cartCheckOutPopVisibility)),
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
