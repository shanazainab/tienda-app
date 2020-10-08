import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/events/saved-card-events.dart';
import 'package:tienda/bloc/saved-card-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/checkout-states.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/view/checkout/address-container.dart';
import 'package:tienda/view/checkout/cart-page.dart';
import 'package:tienda/view/checkout/order-success-page.dart';
import 'package:tienda/view/checkout/payment-container.dart';

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
                DoUpdateCheckOutProgress(order: new Order(), status: "CART"));
          else if (BlocProvider.of<CheckOutBloc>(context).state
              is PaymentActive)
            BlocProvider.of<CheckOutBloc>(context).add(DoUpdateCheckOutProgress(
                order: new Order(), status: "ADDRESS"));
          else if (BlocProvider.of<CheckOutBloc>(context).state is CartActive)
            Navigator.of(context).pop();
          else return Future.value(true);
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              brightness: Brightness.light,
              title: Text(
                '',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            body: MultiBlocListener(
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
                  return Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
//                      SizedBox(
//                        height: 16,
//                      ),
//                      state is Loading
//                          ? Container()
//                          : Row(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                SizedBox(
//                                  width: 8,
//                                ),
//                                Row(
//                                  children: <Widget>[
//                                    Container(
//                                      width: 60,
//                                      height: 2,
//                                      color: state is UpdateCheckoutStatus &&
//                                              (state.status == "ADDRESS" ||
//                                                  state.status == "PAYMENT" ||
//                                                  state.status == "CART")
//                                          ? Colors.green[900]
//                                          : Colors.grey,
//                                    ),
//                                    Icon(
//                                      Icons.check_circle,
//                                      size: 14,
//                                      color: state is UpdateCheckoutStatus &&
//                                              (state.status == "ADDRESS" ||
//                                                  state.status == "PAYMENT" ||
//                                                  state.status == "CART")
//                                          ? Colors.green[900]
//                                          : Colors.grey,
//                                    ),
//                                    Text("Cart"),
//                                  ],
//                                ),
//                                Row(
//                                  children: <Widget>[
//                                    Container(
//                                      width: 60,
//                                      height: 2,
//                                      color: state is UpdateCheckoutStatus &&
//                                              (state.status == "ADDRESS" ||
//                                                  state.status == "PAYMENT")
//                                          ? Colors.green[900]
//                                          : Colors.grey,
//                                    ),
//                                    Icon(
//                                      Icons.check_circle,
//                                      size: 14,
//                                      color: state is UpdateCheckoutStatus &&
//                                              (state.status == "ADDRESS" ||
//                                                  state.status == "PAYMENT")
//                                          ? Colors.green[900]
//                                          : Colors.grey,
//                                    ),
//                                    Text("Address"),
//                                  ],
//                                ),
//                                Row(
//                                  children: <Widget>[
//                                    Container(
//                                      width: 60,
//                                      height: 2,
//                                      color: state is UpdateCheckoutStatus &&
//                                              state.status == "PAYMENT"
//                                          ? Colors.green[900]
//                                          : Colors.grey,
//                                    ),
//                                    Icon(
//                                      Icons.check_circle,
//                                      size: 14,
//                                      color: state is UpdateCheckoutStatus &&
//                                              state.status == "PAYMENT"
//                                          ? Colors.green[900]
//                                          : Colors.grey,
//                                    ),
//                                    Text("Payment"),
//                                  ],
//                                ),
//                              ],
//                            ),
//                      SizedBox(
//                        height: 16,
//                      ),
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
                                        AddressBloc()..add(LoadSavedAddress()),
                                    child: OrderAddressContainer()),
                                BlocProvider<SavedCardBloc>(
                                    create: (BuildContext context) =>
                                    SavedCardBloc()..add(LoadSavedCards()),
                                    child: PaymentContainer()),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }))),
      ),
    );
  }
}
