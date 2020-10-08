import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/states/address-states.dart';
import 'package:tienda/view/widgets/loading-widget.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/delivery-address.dart';
import 'package:tienda/view/address/add-address-page.dart';
import 'package:tienda/view/address/choose-address-page.dart';

class SavedAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext contextB) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(AppLocalizations.of(contextB).translate('delivery-address'),
                        style: Theme.of(contextB).textTheme.headline2),
                  ),
                  BlocBuilder<AddressBloc, AddressStates>(
                      builder: (context, state) {
                    if (state is LoadAddressSuccess)
                      return deliveryAddressBlock(
                          context, state.deliveryAddresses);
                    if (state is DeleteAddressSuccess)
                      return deliveryAddressBlock(
                          context, state.deliveryAddresses);
                    if (state is AddressEmpty)
                      return Container(
                        height: 400,
                        child: Center(child: Text("No Saved Address !!")),
                      );
                    else
                      return Container(
                          height: 400,
                          child: Center(child: spinKit));
                  }),
                ],
              ),
            ),
            BlocBuilder<AddressBloc, AddressStates>(builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          contextB,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                  value: BlocProvider.of<AddressBloc>(contextB),
                                  child: ChooseAddressPage())),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(AppLocalizations.of(contextB).translate('add-new-address').toUpperCase()),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ));
  }

  deliveryAddressBlock(contextA, List<DeliveryAddress> deliveryAddresses) {
    return deliveryAddresses.isNotEmpty
        ? new ListView.separated(
            shrinkWrap: true,
            itemCount: deliveryAddresses.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
                  endIndent: 16,
                  indent: 16,
                ),
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
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
                                  deliveryAddresses[index].addressType ==
                                          "villa"
                                      ? Icons.home
                                      : Icons.location_city,
                                  size: 16,
                                )),
                            Container(
                              width: MediaQuery.of(contextA).size.width - 150,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child:
                                    Text(deliveryAddresses[index].longAddress),
                              ),
                            ),
                            deliveryAddresses[index].isDefault
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text("Default"),
                                    ),
                                  )
                                : Container()
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
                                width: MediaQuery.of(contextA).size.width - 90,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(deliveryAddresses[index].fullName),
                                      Text(
                                          deliveryAddresses[index].phoneNumber),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        deliveryAddresses[index].apartment != "null"
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
                                    width: MediaQuery.of(contextA).size.width -
                                        150,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                          deliveryAddresses[index].apartment),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                BlocProvider.of<AddressBloc>(contextA).add(
                                    DeleteSavedAddress(
                                        deliveryAddresses: deliveryAddresses,
                                        deliveryAddressId:
                                            deliveryAddresses[index].id));
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.delete,
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    AppLocalizations.of(contextA).translate('delete'),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  contextA,
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                            value: BlocProvider.of<AddressBloc>(
                                                contextA),
                                            child: AddAddressPage(
                                              isEditMode: true,
                                              deliveryAddress:
                                                  deliveryAddresses[index],
                                            ),
                                          )),
                                );
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.edit,
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(AppLocalizations.of(contextA).translate('edit'), style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ));
            })
        : Center(
            child: Container(
              height: 400,
              child: Center(child: Text("No saved address !!")),
            ),
          );
  }
}
