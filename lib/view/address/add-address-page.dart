import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/states/address-states.dart';
import 'package:tienda/model/address.dart';
import 'package:tienda/view/address/saved-address-page.dart';
import 'dart:io' show Platform;

import 'package:tienda/view/widgets/custom-app-bar.dart';

class AddAddressPage extends StatefulWidget {
  final DeliveryAddress deliveryAddress;

  AddAddressPage({this.deliveryAddress});

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();

  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AddressBloc(),
        child: BlocListener<AddressBloc, AddressStates>(
          listener: (context, state) {
            if (state is AddAddressSuccess)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SavedAddressPage()),
              );
          },
          child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: SafeArea(
                      child: CustomAppBar(
                    title: "Add Address",
                    showCart: false,
                    showLogo: false,
                    showSearch: false,
                    showWishList: false,
                  ))),
              body: BlocBuilder<AddressBloc, AddressStates>(
                  builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, left: 16),
                          child: Text(
                            "${widget.deliveryAddress.address}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, left: 16),
                          child: Text(
                            "CONTACT INFORMATION",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                        contactInfoWidget(),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, left: 16),
                          child: Text(
                            "LOCATION INFORMATION",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                        locationInfoWidget(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Set as default"),
                            Switch(
                              focusColor: Colors.lightBlue,
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                });
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ButtonTheme(
                            height: 48,
                            minWidth: MediaQuery.of(context).size.width - 48,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(05)),
                            child: RaisedButton(
                              color: Colors.grey,
                              onPressed: () {
                                handleSaveAddress(context);
                              },
                              child: Text(
                                "SAVE ADDRESS",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })),
        ));
  }

  void handleSaveAddress(context) {
    if (_formKey.currentState.validate()) {
      BlocProvider.of<AddressBloc>(context)
          .add(AddSavedAddress(deliveryAddress: widget.deliveryAddress));
    }
  }

  contactInfoWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelText: 'Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide a contact name';
                }
                widget.deliveryAddress.name = value;

                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelText: 'Mobile Number'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a contact name';
                  }
                  widget.deliveryAddress.mobileNumber = int.parse(value);
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  locationInfoWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelText: 'Apartment Name'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelText: 'Floor Number'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextFormField(
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelText: 'Instructions'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
