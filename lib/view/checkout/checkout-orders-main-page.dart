import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/states/address-states.dart';
import 'package:tienda/bloc/states/checkout-states.dart';
import 'package:tienda/view/checkout/checkout-status-container.dart';
import 'package:tienda/view/checkout/order-address-container.dart';
import 'package:tienda/view/checkout/payment-container.dart';

class CheckoutOrdersMainPage extends StatefulWidget {
  @override
  _CheckoutOrdersMainPageState createState() => _CheckoutOrdersMainPageState();
}

class _CheckoutOrdersMainPageState extends State<CheckoutOrdersMainPage> {
  PageController pageController = new PageController(
    initialPage: 0,
  );

  CheckOutBloc checkOutBloc = new CheckOutBloc();

  int addressId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressBloc>(
        create: (BuildContext context) =>
            AddressBloc()..add(LoadSavedAddress()),
        child:BlocListener<AddressBloc, AddressStates>(
          listener: (context, state) {
            if (state is LoadAddressSuccess){
              for(final address in state.deliveryAddresses){
                if(address.isDefault){
                  addressId = address.id;
                  Logger().d("ADDRESS ID:$addressId");

                }
              }
            }
          },
          child: BlocBuilder<CheckOutBloc, CheckoutStates>(
            bloc:checkOutBloc,
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  brightness: Brightness.light,
                  title: Text('CHECKOUT'),
                ),
                bottomNavigationBar: ButtonTheme(
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                     checkOutBloc..add(DoCartCheckout(
                       addressId:addressId
                     ));
                    },
                    child: Text("MAKE PAYMENT"),
                  ),
                ),
                body: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("SUMMARY"),
                          Text("PAYMENT"),
                          Text("COMPLETE"),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          child: PageView(
                            scrollDirection: Axis.horizontal,
                            controller: pageController,
                            children: <Widget>[
                              BlocBuilder<AddressBloc, AddressStates>(
                                  builder: (context, state) {
                                if (state is LoadAddressSuccess)
                                  return OrderAddressContainer(
                                      state.deliveryAddresses);
                                else
                                  return Container();
                              }),
                              PaymentContainer(),
                              CheckoutStatusContainer()
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            })));
  }
}
