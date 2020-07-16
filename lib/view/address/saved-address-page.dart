import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/states/address-states.dart';
import 'package:tienda/view/address/choose-address-page.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';

class SavedAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddressBloc(),
      child: Scaffold(
          appBar:PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: CustomAppBar(
              title: "Saved Address",
              showWishList: false,
              showSearch: false,
              showCart: false,
              showLogo: false,
            ),
          ),
          bottomNavigationBar: ButtonTheme(
            height: 48,
            minWidth: MediaQuery.of(context).size.width - 48,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChooseAddressPage()),
                );
              },
              child: Text("ADD NEW ADDRESS"),
            ),
          ),
          body: BlocBuilder<AddressBloc, AddressStates>(
              builder: (context, state) {
                if (state is LoadAddressSuccess)
                  return Container(
                    color: Colors.white,
                    child: new ListView.separated(
                        itemCount: state.deliveryAddresses.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                              endIndent: 16,
                              indent: 16,
                            ),
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: Container(
                              color: Colors.white,
                              child: ListTile(
                                title: Text(state.deliveryAddresses[index].address),
                                subtitle: Text(state.deliveryAddresses[index].name),
                              ),
                            ),
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
                                  // deleteAddress()
                                },
                              ),
                            ],
                          );
                        }),
                  );
                else
                  return Container(
                    child: Center(
                      child: Text("No Address"),
                    ),
                  );
              })),
    );
  }
}
