import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/states/address-states.dart';
import 'package:tienda/model/delivery-address.dart';
import 'package:tienda/view/address/saved-address-page.dart';

import 'package:tienda/view/widgets/custom-app-bar.dart';

class AddAddressPage extends StatefulWidget {
  final bool isEditMode;

  final DeliveryAddress deliveryAddress;

  AddAddressPage({this.deliveryAddress, this.isEditMode});

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();

  bool isSwitched = false;

  String labelOne = "Apartment name";
  String labelTwo = "Floor number";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.deliveryAddress.addressType = "none";
    widget.deliveryAddress.apartment = "test";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AddressBloc(),
        child: BlocListener<AddressBloc, AddressStates>(
          listener: (context, state) {
            if (state is AddAddressSuccess || state is EditAddressSuccess)
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
                            "${widget.deliveryAddress.longAddress}",
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
                              value: widget.isEditMode?widget.deliveryAddress.isDefault:isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                  widget.deliveryAddress.isDefault = isSwitched;
                                });
                              },
                              activeTrackColor: Colors.lightBlueAccent,
                              activeColor: Colors.lightBlue,
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
                                widget.isEditMode ? "UPDATE" : "SAVE ADDRESS",
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
              initialValue:
                  widget.isEditMode ? widget.deliveryAddress.fullName : null,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 8, top: 8),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelText: 'Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide a contact name';
                }
                widget.deliveryAddress.fullName = value;

                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextFormField(
                initialValue:
                widget.isEditMode ? widget.deliveryAddress.phoneNumber : null,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8, top: 8),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelText: 'Mobile Number'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a contact name';
                  }
                  widget.deliveryAddress.phoneNumber = value;
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
                    setState(() {
                      labelOne = "Apartment name";
                      labelTwo = "Floor Number";
                    });
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 4, bottom: 4),
                      child: Text("Apartment"),
                    ),
                    color: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.deliveryAddress.addressType = "villa";
                    setState(() {
                      labelOne = "Villa name";
                      labelTwo = "Street";
                    });
                  },
                  child: Card(
                      color: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 4, bottom: 4),
                        child: Text("Villa"),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    widget.deliveryAddress.addressType = "office";
                    setState(() {
                      labelOne = "Office";
                      labelTwo = "Floor number";
                    });
                  },
                  child: Card(
                      color: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 4, bottom: 4),
                        child: Text("Office"),
                      )),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue:
                    widget.isEditMode ? widget.deliveryAddress.buildingName : null,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    validator: (value) {
                      widget.deliveryAddress.buildingName = value;

                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8, top: 8),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelText: labelOne),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextFormField(
                      initialValue:
                      widget.isEditMode ? widget.deliveryAddress.floor : null,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      validator: (value) {
                        widget.deliveryAddress.floor = value;

                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 8, top: 8),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey[100],
                          labelText: labelTwo),
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
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          initialValue:
          widget.isEditMode ? widget.deliveryAddress.comment : null,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          validator: (value) {
            widget.deliveryAddress.comment = value;

            return null;
          },
          minLines: 2,
          maxLines: 4,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 8, top: 8),
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

      if(widget.isEditMode){
        BlocProvider.of<AddressBloc>(context)
            .add(EditSavedAddress(deliveryAddress: widget.deliveryAddress));
      }else {
        BlocProvider.of<AddressBloc>(context)
            .add(AddSavedAddress(deliveryAddress: widget.deliveryAddress));
      }
    }
  }
}
