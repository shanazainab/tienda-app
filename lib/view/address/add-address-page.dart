import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/states/address-states.dart';
import 'package:tienda/model/delivery-address.dart';
import 'package:tienda/view/address/saved-address-page.dart';

class AddAddressPage extends StatefulWidget {
  final bool isEditMode;

  final bool fromCheckOut;

  final DeliveryAddress deliveryAddress;

  AddAddressPage({this.deliveryAddress, this.isEditMode, this.fromCheckOut});

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
    widget.deliveryAddress.addressType = "apartment";
    widget.deliveryAddress.apartment = "null";
    widget.deliveryAddress.isDefault = false;
  }

  @override
  Widget build(BuildContext contextA) {
    return BlocListener<AddressBloc, AddressStates>(
      listener: (context, state) {
        if (state is LoadAddressSuccess &&
            (widget.fromCheckOut == null || !widget.fromCheckOut))
          Navigator.of(context).pop();
        else if (state is LoadAddressSuccess && widget.fromCheckOut)
          Navigator.of(context).pop();
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            brightness: Brightness.light,
            title: Text("Add Address"),
          ),
          bottomNavigationBar: BlocBuilder<AddressBloc, AddressStates>(
              builder: (context, state) {
            if (state is Loading)
              return LinearProgressIndicator();
            else
              return Container(
                height: 0,
                width: 0,
              );
          }),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              color: Colors.white,
              child: BlocBuilder<AddressBloc, AddressStates>(
                  builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "${widget.deliveryAddress.longAddress}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        contactInfoWidget(),
                        SizedBox(
                          height: 16,
                        ),
                        locationInfoWidget(),
                        SizedBox(
                          height: 16,
                        ),
                        personalInstructionWidget(),
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Set as default"),
                                  Switch(
                                    value: widget.isEditMode
                                        ? widget.deliveryAddress.isDefault
                                        : isSwitched,
                                    onChanged: (value) {
                                      setState(() {
                                        isSwitched = value;
                                        widget.deliveryAddress.isDefault =
                                            isSwitched;
                                      });
                                    },
                                    activeTrackColor:
                                        Colors.black.withOpacity(0.1),
                                    activeColor: Colors.black,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: RaisedButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      if (BlocProvider.of<AddressBloc>(context)
                                          .state is Loading) {
                                      } else
                                        handleSaveAddress(context);
                                    },
                                    child: Text(
                                      widget.isEditMode
                                          ? "UPDATE"
                                          : "SAVE ADDRESS",
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          )),
    );
  }

  contactInfoWidget() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("CONTACT PERSON"),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              initialValue:
                  widget.isEditMode ? widget.deliveryAddress.fullName : null,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: InputBorder.none,
                  filled: true,
                  labelStyle: TextStyle(fontSize: 12),
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
                initialValue: widget.isEditMode
                    ? widget.deliveryAddress.phoneNumber
                    : null,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: InputBorder.none,
                    labelStyle: TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelText: 'Mobile Number'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a contact number';
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
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("LOCATION"),
            SizedBox(
              height: 16,
            ),
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
                      child: Text(
                        "APARTMENT",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: widget.deliveryAddress.addressType == "apartment"
                            ? BorderSide(color: Colors.grey)
                            : BorderSide.none,
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
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: widget.deliveryAddress.addressType == "villa"
                              ? BorderSide(color: Colors.grey)
                              : BorderSide.none,
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 4, bottom: 4),
                        child: Text(
                          "VILLA",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
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
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: widget.deliveryAddress.addressType == "office"
                              ? BorderSide(color: Colors.grey)
                              : BorderSide.none,
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 4, bottom: 4),
                        child: Text(
                          "OFFICE",
                          style: TextStyle(fontSize: 12),
                        ),
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
                    initialValue: widget.isEditMode
                        ? widget.deliveryAddress.buildingName
                        : null,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    validator: (value) {
                      widget.deliveryAddress.buildingName = value;

                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        border: InputBorder.none,
                        filled: true,
                        labelStyle: TextStyle(fontSize: 12),
                        fillColor: Colors.grey[100],
                        labelText: labelOne),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextFormField(
                      initialValue: widget.isEditMode
                          ? widget.deliveryAddress.floor
                          : null,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      validator: (value) {
                        widget.deliveryAddress.floor = value;

                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: InputBorder.none,
                          filled: true,
                          labelStyle: TextStyle(fontSize: 12),
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
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("INSTRUCTION"),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              initialValue:
                  widget.isEditMode ? widget.deliveryAddress.comment : null,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
              validator: (value) {
                widget.deliveryAddress.comment = value;

                return null;
              },
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: InputBorder.none,
                  filled: true,
                  labelStyle: TextStyle(fontSize: 12),
                  fillColor: Colors.grey[100],
                  labelText: 'Instructions'),
            ),
          ],
        ),
      ),
    );
  }

  void handleSaveAddress(context) {
    if (_formKey.currentState.validate()) {
      Logger().d("DELIVERY ADDRESS:${widget.deliveryAddress}");

      if (widget.isEditMode) {
        BlocProvider.of<AddressBloc>(context).add(EditSavedAddress(
          deliveryAddress: widget.deliveryAddress,
        ));
      } else {
        BlocProvider.of<AddressBloc>(context).add(AddSavedAddress(
          deliveryAddress: widget.deliveryAddress,
        ));
      }
    }
  }
}
