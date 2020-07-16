import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/states/address-states.dart';
import 'package:tienda/model/delivery-address.dart';
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

  PageController pageController = new PageController(initialPage: 0);
  bool isSwitched = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.deliveryAddress.addressType = "none";
  }

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
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, left: 16),
                          child: Text(
                            "INSTRUCTION",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                        personalInstructionWidget(),
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
                                  widget.deliveryAddress.isDefault = isSwitched;
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    widget.deliveryAddress.addressType = "apartment";

                    pageController.animateToPage(0,
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOutCubic);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text("Apartment"),
                    ),
                    color: Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.deliveryAddress.addressType = "villa";

                    pageController.animateToPage(1,
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOutCubic);
                  },
                  child: Card(
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text("Villa"),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    widget.deliveryAddress.addressType = "office";

                    pageController.animateToPage(2,
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOutCubic);
                  },
                  child: Card(
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text("Office"),
                      )),
                )
              ],
            ),
            Container(
              height: 200,
              child: PageView(
                controller: pageController,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            widget.deliveryAddress.buildingName = value;

                            return null;
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelText: 'Apartment Name'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextFormField(
                            validator: (value) {
                              widget.deliveryAddress.floorNUmber = value;

                              return null;
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[100],
                                labelText: 'Floor Number'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            widget.deliveryAddress.villaName = value;

                            return null;
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelText: 'Villa Name'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextFormField(
                            validator: (value) {
                              widget.deliveryAddress.floorNUmber = value;

                              return null;
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[100],
                                labelText: 'Villa Number'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (value) {
                              widget.deliveryAddress.buildingName = value;

                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[100],
                                labelText: 'Office'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: TextFormField(
                              validator: (value) {
                                widget.deliveryAddress.floorNUmber = value;

                                return null;
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  labelText: 'Floor Number'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  personalInstructionWidget() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: TextFormField(
          validator: (value) {
            widget.deliveryAddress.instruction = value;

            return null;
          },
          minLines: 2,
          maxLines: 4,
          decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[100],
              labelText: 'Instructions'),
        ),
      ),
    );
  }

  void handleSaveAddress(context) {
    if (_formKey.currentState.validate()) {
      Logger().d("DELIVERY ADDRESS:${widget.deliveryAddress}");

      BlocProvider.of<AddressBloc>(context)
          .add(AddSavedAddress(deliveryAddress: widget.deliveryAddress));
    }
  }
}
