import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/loading-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/cart.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/view/checkout/price-details-container.dart';
import 'package:tienda/view/login/login-main-page.dart';

class CartBottomBar extends StatefulWidget {
  final Cart cart;

  CartBottomBar(this.cart);

  @override
  _CartBottomBarState createState() => _CartBottomBarState();
}

class _CartBottomBarState extends State<CartBottomBar> {
  bool showPriceDetails = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      elevation: 20,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 18, left: 16.0, right: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(children: [
                  Text(
                    "TOTAL",
                    style: TextStyle(
                      color: Color(0xff282828),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showPriceDetails = !showPriceDetails;
                      });
                    },
                    child: Text(
                      "Show details",
                      style: TextStyle(
                        color: Color(0xffaf0044),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ]),
                Text(
                  "${AppLocalizations.of(context).translate('aed')} ${(widget.cart.summary.totalPrice).toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Color(0xff282828),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
              visible: showPriceDetails,
              child: PriceDetailsContainer(
                summary: widget.cart.summary,
              )),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
                width: MediaQuery.of(context).size.width - 24,
                height: 48,
                child: BlocBuilder<LoadingBloc, LoadingStates>(
                    builder: (context, state) {
                  if (state is AppLoading) {
                    return RaisedButton(
                      onPressed: () {
                        //Do nothing
                      },
                      child: Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  } else {
                    return RaisedButton(
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context).state is GuestUser
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginMainPage()),
                                )
                              : BlocProvider.of<CheckOutBloc>(context).add(
                                  DoUpdateCheckOutProgress(
                                      order: new Order(), status: "ADDRESS"));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/shopping-bag.svg",
                              height: 16,
                              width: 16,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Proceed to Checkout'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ));
                  }
                })),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
