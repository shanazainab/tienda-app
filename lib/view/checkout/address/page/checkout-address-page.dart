import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/states/address-states.dart';
import 'package:tienda/model/delivery-address.dart';
import 'package:tienda/view/address/google-maps-container.dart';
import 'package:tienda/view/checkout/address/widget/add-address-container.dart';
import 'package:tienda/view/checkout/address/widget/saved-address-container.dart';
import 'package:tienda/view/login/login-main-page.dart';

class CheckOutAddressPage extends StatefulWidget {
  @override
  _CheckOutAddressPageState createState() => _CheckOutAddressPageState();
}

class _CheckOutAddressPageState extends State<CheckOutAddressPage> {
  DeliveryAddress updateAddress = new DeliveryAddress();
  List<DeliveryAddress> savedAddresses = new List();

  int _selectedIndex = 0;
  bool editMode = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<AddressBloc, AddressStates>(listener: (context, state) {
            if (state is LoadAddressSuccess) {
              if (state.deliveryAddresses.length == 1) {
                BlocProvider.of<CheckOutBloc>(context)
                  ..add(DoCartCheckoutProgressUpdate(
                      deliveryAddress: state.deliveryAddresses[0],
                      checkOutStatus: 'ADDRESS',
                      fromLiveStream: false));
              } else {
                for (final address in state.deliveryAddresses) {
                  if (address.isDefault) {
                    BlocProvider.of<CheckOutBloc>(context)
                      ..add(DoCartCheckoutProgressUpdate(
                          deliveryAddress: address,
                          checkOutStatus: 'ADDRESS',
                          fromLiveStream: false));
                  }
                }
              }
              savedAddresses.clear();
              savedAddresses.addAll(state.deliveryAddresses);
              setState(() {
                _selectedIndex = 0;
              });
            } else if (state is AuthorizationFailed) {
              Navigator.of(context, rootNavigator: false).push(
                MaterialPageRoute(
                  builder: (context) => LoginMainPage(),
                ),
              );
            } else if (state is AddressEmpty) {
              setState(() {
                _selectedIndex = 1;
              });
            }
          })
        ],
        child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                brightness: Brightness.light,
                title: Text(
                  'Choose Delivery Address',
                  style: const TextStyle(
                      color: const Color(0xff282828),
                      fontWeight: FontWeight.w700,
                      fontFamily: "SFProText",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                )),
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                SavedDeliveryAddresses(
                  buildContext:context,
                  savedAddresses: savedAddresses,
                  onClickAddNewAddress: (edit, deliveryAddress) {
                    setState(() {
                      print(edit);
                      if (edit)
                        _selectedIndex = 2;
                      else
                        _selectedIndex = 1;

                      editMode = edit;
                      updateAddress = deliveryAddress;
                    });
                  },
                ),

                ///google container
                ///
                GoogleMapsContainer((deliveryAddress) {
                  updateAddress = deliveryAddress;
                  print(updateAddress);
                  setState(() {
                    _selectedIndex = 2;
                  });
                }),

                ///add address
                AddAddressContainer(
                  deliveryAddress: updateAddress,
                  isEditMode: editMode,
                )
              ],
            )));
  }
}
