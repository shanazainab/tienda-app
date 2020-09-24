import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/model/delivery-address.dart';
import 'package:tienda/view/address/add-address-page.dart';

class SavedDeliveryAddresses extends StatelessWidget {
  const SavedDeliveryAddresses({
    Key key,
    @required this.chosenAddress,
    @required this.savedAddresses,
    @required this.contextA,
  }) : super(key: key);

  final BehaviorSubject<int> chosenAddress;
  final List<DeliveryAddress> savedAddresses;
  final BuildContext contextA;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: savedAddresses.length,
        itemBuilder: (BuildContext context, int index) {
          return savedAddresses.isNotEmpty
              ? StreamBuilder<int>(
                  stream: chosenAddress,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    return GestureDetector(
                      onTap: () {
                        chosenAddress.add(savedAddresses[index].id);

                        ///Record shipping related information
                        // FirebaseAnalytics().logEvent(
                        //     name: 'ADD_SHIPPING_INFO', parameters: {
                        //       ''
                        // });
                      },
                      child: Container(
                          color: snapshot.data == savedAddresses[index].id
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
                                      width: MediaQuery.of(context).size.width -
                                          182,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                            savedAddresses[index].longAddress),
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
                                                contextA,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BlocProvider.value(
                                                          value: BlocProvider
                                                              .of<AddressBloc>(
                                                                  contextA),
                                                          child: AddAddressPage(
                                                            isEditMode: true,
                                                            fromCheckOut: true,
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
                                        width:
                                            MediaQuery.of(context).size.width -
                                                90,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
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
                                              child: Text(savedAddresses[index]
                                                  .apartment),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          )),
                    );
                  })
              : Container(
                  child: Text("Looks like no address, Add new"),
                );
        });
  }
}
