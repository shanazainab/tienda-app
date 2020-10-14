import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/bottom-nav-bar-bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/events/bottom-nav-bar-events.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/events/saved-card-events.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/saved-card-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/checkout-states.dart';
import 'package:tienda/bloc/states/loading-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/view/checkout/address-container.dart';
import 'package:tienda/view/checkout/cart-bottom-bar.dart';
import 'package:tienda/view/checkout/cart-page.dart';
import 'package:tienda/view/checkout/order-success-page.dart';
import 'package:tienda/view/checkout/payment-container.dart';
import 'package:tienda/view/checkout/price-details-container.dart';
import 'package:tienda/view/login/login-main-page.dart';

class CheckoutOrdersMainPage extends StatefulWidget {
  @override
  _CheckoutOrdersMainPageState createState() => _CheckoutOrdersMainPageState();
}

class _CheckoutOrdersMainPageState extends State<CheckoutOrdersMainPage> {
  PageController pageController = new PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<CartBloc>(context)..add(FetchCartData()),
        child: WillPopScope(
            onWillPop: () {
              if (BlocProvider.of<CheckOutBloc>(context).state is AddressActive)
                BlocProvider.of<CheckOutBloc>(context).add(
                    DoUpdateCheckOutProgress(
                        order: new Order(), status: "CART"));
              else if (BlocProvider.of<CheckOutBloc>(context).state
                  is PaymentActive)
                BlocProvider.of<CheckOutBloc>(context).add(
                    DoUpdateCheckOutProgress(
                        order: new Order(), status: "ADDRESS"));
              else if (BlocProvider.of<CheckOutBloc>(context).state
                  is CartActive) {
                BlocProvider.of<BottomNavBarBloc>(context)
                    .add(ChangeBottomNavBarState(0, false));
                Navigator.of(context).pop();
              } else {
                BlocProvider.of<BottomNavBarBloc>(context)
                    .add(ChangeBottomNavBarState(0, false));
                return Future.value(true);
              }
              return Future.value(false);
            },
            child: MultiBlocListener(
                listeners: [
                  BlocListener<CartBloc, CartStates>(
                    listener: (context, state) {
                      if (state is LoadCartSuccess && state.cart != null)
                        BlocProvider.of<CheckOutBloc>(context).add(
                            DoUpdateCheckOutProgress(
                                order: new Order(), status: "CART"));
                    },
                  ),
                  BlocListener<CheckOutBloc, CheckoutStates>(
                    listener: (context, state) {
                      if (state is AddressActive) {
                        pageController.animateToPage(1,
                            duration: Duration(
                              milliseconds: 300,
                            ),
                            curve: Curves.easeIn);
                      }
                      if (state is PaymentActive)
                        pageController.animateToPage(2,
                            duration: Duration(
                              milliseconds: 300,
                            ),
                            curve: Curves.easeIn);
                      if (state is CartActive)
                        pageController.animateToPage(0,
                            duration: Duration(
                              milliseconds: 300,
                            ),
                            curve: Curves.easeIn);

                      if (state is InitialCheckOutSuccess) {
                        ///Empty the cart
                        BlocProvider.of<CartBloc>(context).add(ClearCart());

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    OrderSuccessPage()));
                      }
                    },
                  )
                ],
                child: BlocBuilder<CheckOutBloc, CheckoutStates>(
                    builder: (context, state) {
                  return Scaffold(
                    appBar: AppBar(
                        elevation: 0,
                        centerTitle: true,
                        brightness: Brightness.light,
                        title: state is CartActive
                            ? BlocBuilder<CartBloc, CartStates>(
                                builder: (context, cartState) {
                                if (cartState is LoadCartSuccess &&
                                    cartState.cart != null)
                                  return Text(
                                      'Shopping Bag (${cartState.cart.products.length})',
                                      style: const TextStyle(
                                          color: const Color(0xff282828),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "SFProText",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16.0),
                                      textAlign: TextAlign.center);
                                else
                                  return Text('Shopping Bag',
                                      style: const TextStyle(
                                          color: const Color(0xff282828),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "SFProText",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16.0),
                                      textAlign: TextAlign.center);
                              })
                            : Text('')),
                    bottomNavigationBar: state is CartActive
                        ? BlocBuilder<CartBloc, CartStates>(
                            builder: (context, cartState) {
                            if (cartState is LoadCartSuccess &&
                                cartState.cart != null) {
                              return CartBottomBar(cartState.cart);
                            }
                            return Container(
                              height: 0,
                            );
                          })
                        : Container(
                            height: 0,
                          ),
                    body: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: PageView(
                                physics: new NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                controller: pageController,
                                children: <Widget>[
                                  CartPage(),
                                  BlocProvider<AddressBloc>(
                                      create: (BuildContext context) =>
                                          AddressBloc()
                                            ..add(LoadSavedAddress()),
                                      child: OrderAddressContainer()),
                                  BlocProvider<SavedCardBloc>(
                                      create: (BuildContext context) =>
                                          SavedCardBloc()
                                            ..add(LoadSavedCards()),
                                      child: PaymentContainer()),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }))));
  }
}
