import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/checkout-states.dart';

class PaymentContainer extends StatelessWidget {
  @override
  Widget build(BuildContext contextA) {
    return BlocBuilder<CheckOutBloc, CheckoutStates>(builder: (context, state) {
      if (state is PaymentActive)
        return Stack(
          children: <Widget>[
            Container(child: buildPaymentOptionBlock(contextA)),
            BlocBuilder<CartBloc, CartStates>(builder: (context, cartState) {
              if (cartState is LoadCartSuccess) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.grey[200],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "AED ${cartState.cart.cartPrice - 0}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: RaisedButton(
                            onPressed: () {
                              BlocProvider.of<CheckOutBloc>(context).add(
                                  DoCartCheckout(
                                      addressId: state.order.addressId));
                            },
                            child: Text("PAY NOW"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else
                return Container();
            })
          ],
        );
      else
        return Container();
    });
  }

  buildPaymentOptionBlock(BuildContext contextA) {
    return Container(
      child: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'SAVED PAYMENT METHODS',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Emirates NBD'),
                  Text('****3424'),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('VISA'),
                  Text('John Doe'),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "OTHER PAYMENT METHODS",
            style: TextStyle(color: Colors.grey),
          ),
          ListTile(
            title: Text('Pay on delivery'),
            trailing: Icon(Icons.keyboard_arrow_down),
          ),
          Divider(),
          ListTile(
            title: Text('Credit/Debit Card'),
            trailing: Icon(Icons.keyboard_arrow_down),
          ),
          Divider(),
          ListTile(
            title: Text('Apple Pay'),
            trailing: Icon(Icons.keyboard_arrow_down),
          ),
          Divider(),
          ListTile(
            title: Text('Net Banking'),
            trailing: Icon(Icons.keyboard_arrow_down),
          )
        ],
      ),
    );
  }
}
