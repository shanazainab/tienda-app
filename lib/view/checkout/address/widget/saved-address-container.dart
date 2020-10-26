import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/events/saved-card-events.dart';
import 'package:tienda/bloc/saved-card-bloc.dart';
import 'package:tienda/bloc/states/checkout-states.dart';
import 'package:tienda/model/delivery-address.dart';
import 'package:tienda/view/address/add-address-page.dart';
import 'package:tienda/view/checkout/payment/payment-page.dart';

typedef OnClickAddNewAddress = Function(
    bool editMode, DeliveryAddress deliveryAddress);

class SavedDeliveryAddresses extends StatelessWidget {
  const SavedDeliveryAddresses({
    Key key,
    @required this.buildContext,
    @required this.savedAddresses,
    @required this.onClickAddNewAddress,
  }) : super(key: key);

  final List<DeliveryAddress> savedAddresses;

  final BuildContext buildContext;
  final OnClickAddNewAddress onClickAddNewAddress;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: savedAddresses.length,
                itemBuilder: (BuildContext context, int index) {
                  return BlocBuilder<CheckOutBloc, CheckoutStates>(
                      builder: (context, state) {
                    if (state is DoCartCheckoutUpdateSuccess)
                      return GestureDetector(
                        onTap: () {
                          BlocProvider.of<CheckOutBloc>(context)
                              .add(DoCartCheckoutProgressUpdate(
                            deliveryAddress: savedAddresses[index],
                            checkOutStatus: 'ADDRESS',
                            fromLiveStream: false,
                          ));
                        },
                        child: Container(
                            color: state.deliveryAddress.id == savedAddresses[index].id
                                ? Colors.grey[200]
                                : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.center,
                                          width: 50,
                                          child: Icon(
                                            savedAddresses[index].addressType ==
                                                    "villa"
                                                ? Icons.home
                                                : Icons.location_city,
                                            size: 16,
                                          )),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                182,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Text(savedAddresses[index]
                                              .longAddress),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            savedAddresses[index].isDefault
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: Text("Default"),
                                                    ),
                                                  )
                                                : Container(),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BlocProvider.value(
                                                            value: BlocProvider
                                                                .of<AddressBloc>(
                                                                    context),
                                                            child:
                                                                AddAddressPage(
                                                              isEditMode: true,
                                                              deliveryAddress:
                                                                  savedAddresses[
                                                                      index],
                                                            ),
                                                          )),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  "EDIT",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.blue),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          width: 50,
                                          child: Icon(
                                            Icons.phone,
                                            size: 16,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              90,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(savedAddresses[index]
                                                    .fullName),
                                                Text(savedAddresses[index]
                                                    .phoneNumber),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  savedAddresses[index].apartment != "null"
                                      ? Row(
                                          children: <Widget>[
                                            Container(
                                                alignment: Alignment.center,
                                                width: 50,
                                                child: Icon(
                                                  Icons.location_on,
                                                  size: 16,
                                                )),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  150,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text(
                                                    savedAddresses[index]
                                                        .buildingName),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            )),
                      );
                    else
                      return Container();
                  });
                }),
            FlatButton(
              onPressed: () {
                onClickAddNewAddress(false, new DeliveryAddress());
              },
              child: Text(
                "ADD NEW ADDRESS",
                style: TextStyle(
                    color: Color(0xff50C0A8), fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ButtonTheme(
            minWidth: MediaQuery.of(context).size.width - 32,
            child: RaisedButton(
              color: Color(0xff50C0A8),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: BlocProvider.of<CheckOutBloc>(buildContext),
                        ),
                        BlocProvider<SavedCardBloc>(
                          create: (BuildContext context) =>
                              SavedCardBloc()..add(LoadSavedCards()),
                        ),
                      ],
                      child: PaymentPage(),
                    ),
                  ),
                );
              },
              child: Text("CONTINUE"),
            ),
          ),
        )
      ],
    );
  }
}
