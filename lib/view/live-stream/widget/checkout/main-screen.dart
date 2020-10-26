import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/live-stream-checkout-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/checkout-states.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';
import 'package:tienda/model/delivery-address.dart';
import 'package:tienda/model/payment-card.dart';

typedef OnRedirection = Function(int index);

class CheckOutMainScreen extends StatelessWidget {
  final OnRedirection onRedirection;

  CheckOutMainScreen({this.onRedirection});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveStreamCheckOutBloc, CheckoutStates>(
        builder: (context, state) {
      if (state is LiveCheckoutInitializationComplete)
        return buildContents(state.deliveryAddress, state.card);
      if (state is UpdateLiveCheckoutComplete)
        return buildContents(state.deliveryAddress, state.card);
      else
        return Container();
    });
  }

  buildContents(DeliveryAddress deliveryAddress, PaymentCard card) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ///Customer primary contact details

            BlocBuilder<CustomerProfileBloc, CustomerProfileStates>(
                builder: (context, substate) {
              if (substate is LoadCustomerProfileSuccess) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        topLeft: Radius.circular(12)),
                    color: const Color(0xffe5e5e5),
                  ),
                  height: 42,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            "${substate.customerDetails.email}  +${substate.customerDetails.phoneNumber}",
                            style: TextStyle(
                              color: Color(0xff555555),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0,
                            )),
                        IconButton(icon: Icon(Icons.close), onPressed: () {})
                      ],
                    ),
                  ),
                );
              } else
                return Container();
            }),

            ///Default delivery address or last used address or only one saved address if exist(which will be by default )

            SizedBox(
              height: 4,
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  deliveryAddress != null
                      ? ListTile(
                          onTap: () {
                            onRedirection(1);
                          },
                          contentPadding: EdgeInsets.all(0),
                          title: Text(deliveryAddress.addressType),
                          subtitle: Text(deliveryAddress.fullName,
                              style: const TextStyle(
                                  color: const Color(0xff555555),
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              textAlign: TextAlign.left),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        )
                      : ListTile(
                          onTap: () {
                            onRedirection(1);
                          },
                          contentPadding: EdgeInsets.all(0),
                          title: Text("Delivery Address"),
                          subtitle: Text("ADD NEW ADDRESS",
                              style: TextStyle(
                                color: Color(0xff149579),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0,
                              ),
                              textAlign: TextAlign.left),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        ),

                  ///Saved card, last used payment method,

                  Divider(),
                  card != null
                      ? ListTile(
                          onTap: () {
                            onRedirection(2);
                          },
                          contentPadding: EdgeInsets.all(0),
                          title: Text("Credit/Debit Card",
                              style: TextStyle(
                                color: Color(0xff282828),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0,
                              )),
                          subtitle: Container(
                            width: 200,
                            child: Column(
                              children: [
                                TextFormField(),
                                TextFormField(),
                              ],
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        )
                      : ListTile(
                          onTap: () {
                            onRedirection(2);
                          },
                          contentPadding: EdgeInsets.all(0),
                          title: Text("Credit/Debit Card",
                              style: TextStyle(
                                color: Color(0xff282828),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0,
                              )),
                          subtitle: Text("ADD A NEW CARD",
                              style: TextStyle(
                                color: Color(0xff149579),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0,
                              )),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        )
                ],
              ),
            )
          ],
        ),

        ///payment details bottom container
        BlocBuilder<CartBloc, CartStates>(builder: (context, cartState) {
          if (cartState is LoadCartSuccess) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Card(
                  elevation: 16,
                  margin: EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Payment Details",
                            style: TextStyle(
                              color: Color(0xff282828),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0,
                            )),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Subtotal",
                                style: TextStyle(
                                  color: Color(0xff555555),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0,
                                )),
                            Text("${cartState.cart.summary.totalPrice} AED",
                                style: TextStyle(
                                  color: Color(0xff282828),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0,
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Shipping",
                                style: TextStyle(
                                  color: Color(0xff149579),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0,
                                )),
                            Text("FREE",
                                style: TextStyle(
                                  color: Color(0xff149579),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0,
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("Total",
                                    style: TextStyle(
                                      color: Color(0xff555555),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0,
                                    )),
                                SizedBox(
                                  width: 4,
                                ),
                                Text("Including all taxes/duties",
                                    style: TextStyle(
                                      color: Color(0xff555555),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0,
                                    ))
                              ],
                            ),
                            Text("${cartState.cart.summary.totalPrice} AED",
                                style: TextStyle(
                                  color: Color(0xff282828),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0,
                                ))
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            onPressed: () {},
                            child: Text("Buy Now",
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else
            return Container();
        })
      ],
    );
  }
}
