import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/states/address-states.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/view/widgets/loading-widget.dart';
import 'package:tienda/model/delivery-address.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/view/address/add-address-page.dart';
import 'package:tienda/view/address/choose-address-page.dart';
import 'package:tienda/view/checkout/saved-address-block.dart';
import 'package:tienda/view/login/login-main-page.dart';

class OrderAddressContainer extends StatelessWidget {
  final chosenAddress = new BehaviorSubject<int>();

  @override
  Widget build(BuildContext contextA) {
    return BlocListener<AddressBloc, AddressStates>(listener: (context, state) {
      if (state is LoadAddressSuccess) {
        if (state.deliveryAddresses.length == 1) {
          chosenAddress.add(state.deliveryAddresses[0].id);
        } else {
          for (final address in state.deliveryAddresses) {
            if (address.isDefault) {
              chosenAddress.add(address.id);
            }
          }
        }
      } else if (state is AuthorizationFailed) {
        Navigator.push(
          contextA,
          MaterialPageRoute(builder: (context) => LoginMainPage()),
        );
      } else if (state is AddressEmpty) {
        Navigator.push(
          contextA,
          MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                    value: BlocProvider.of<AddressBloc>(contextA),
                    child: ChooseAddressPage(),
                  )),
        );
      }
    }, child:
        BlocBuilder<AddressBloc, AddressStates>(builder: (context, state) {
      if (state is LoadAddressSuccess)
        return Stack(
          children: <Widget>[
            Container(
                child: buildDefaultAddressBlock(
                    state.deliveryAddresses, contextA)),
            BlocBuilder<CartBloc, CartStates>(builder: (context, state) {
              if (state is LoadCartSuccess) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "TOTAL: AED ${state.cart.cartPrice - 0}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 50,
                            child: RaisedButton(
                              onPressed: () {
                                if (chosenAddress.value == null) {
                                  Fluttertoast.showToast(
                                      msg: "Choose a delivery address");
                                } else
                                  BlocProvider.of<CheckOutBloc>(context).add(
                                      DoUpdateCheckOutProgress(
                                          order: new Order(
                                              addressId: chosenAddress.value),
                                          status: "PAYMENT"));
                              },
                              child: Text("CONTINUE"),
                            ),
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
        return Container(
          child: Center(child: spinKit),
        );
    }));
  }

  buildDefaultAddressBlock(List<DeliveryAddress> savedAddresses, contextA) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Delivery Address",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SavedDeliveryAddresses(savedAddresses: savedAddresses,chosenAddress:chosenAddress,contextA: contextA,),
        OutlineButton(
          onPressed: () {
            Navigator.push(
              contextA,
              MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                        value: BlocProvider.of<AddressBloc>(contextA),
                        child: AddAddressPage(
                            isEditMode: true,
                            fromCheckOut: true,
                            deliveryAddress: new DeliveryAddress()),
                      )),
            );
          },
          child: Text(
            "+ ADD NEW ADDRESS",
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
