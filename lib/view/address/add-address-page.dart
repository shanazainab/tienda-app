import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/states/address-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/delivery-address.dart';

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

  String labelOne;
  String labelTwo;

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
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          title: Text(AppLocalizations.of(context)
              .translate("add-address")
              .toUpperCase()),
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
                                Text(AppLocalizations.of(context)
                                    .translate("set-as-default")),
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
                                        ? AppLocalizations.of(context)
                                            .translate("update")
                                            .toUpperCase()
                                        : AppLocalizations.of(context)
                                            .translate("save-address")
                                            .toUpperCase(),
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
        ));
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
            Text(AppLocalizations.of(context).translate("contact-person")),
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
                  labelText: AppLocalizations.of(context).translate("name")),
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
                    labelText:
                        AppLocalizations.of(context).translate("phone-number")),
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
            Text(AppLocalizations.of(context)
                .translate("location")
                .toUpperCase()),
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
                      labelOne =
                          "${AppLocalizations.of(context).translate("apartment")} ${AppLocalizations.of(context).translate("name")}";
                      labelTwo = AppLocalizations.of(context)
                          .translate("floor-number");
                    });
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 4, bottom: 4),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate("apartment")
                            .toUpperCase(),
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
                      labelOne =
                          "${AppLocalizations.of(context).translate("villa")} ${AppLocalizations.of(context).translate("name")}";
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
                          AppLocalizations.of(context)
                              .translate("villa")
                              .toUpperCase(),
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
                      labelOne =
                          AppLocalizations.of(context).translate("office");
                      labelTwo = AppLocalizations.of(context)
                          .translate("floor-number");
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
                          AppLocalizations.of(context)
                              .translate("office")
                              .toUpperCase(),
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
                        labelText: labelOne == null
                            ? "${AppLocalizations.of(context).translate("apartment")} ${AppLocalizations.of(context).translate("name")}"
                            : labelOne),
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
                          labelText: labelOne == null
                              ? "${AppLocalizations.of(context).translate("floor-number")}"
                              : labelOne),
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
            Text(AppLocalizations.of(context)
                .translate("instruction")
                .toUpperCase()),
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
                  labelText: 'eg: leave at reception'),
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
