import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/states/address-states.dart';
import 'package:tienda/view/address/add-address-page.dart';
import 'package:tienda/view/address/choose-address-page.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';

class SavedAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddressBloc()..add(LoadSavedAddress()),
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
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddAddressPage()),
                                );
                              },
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Icon(Icons.business),
                                        Padding(
                                          padding: const EdgeInsets.only(left:16.0),
                                          child: Text(state.deliveryAddresses[index].longAddress),
                                        ),

                                      ],),
                                      Padding(
                                        padding: const EdgeInsets.only(top:8.0),
                                        child: Row(children: <Widget>[
                                          Icon(Icons.phone),
                                          Padding(
                                            padding: const EdgeInsets.only(left:16.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(state.deliveryAddresses[index].fullName),
                                                Text(state.deliveryAddresses[index].phoneNumber),

                                              ],
                                            ),
                                          )

                                        ],),
                                      )

                                    ],
                                  ),
                                )
                              ),
                            ),
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
                                 context.bloc<AddressBloc>().add(DeleteSavedAddress(deliveryAddressId: state.deliveryAddresses[index].id));
                                },
                              ),
                            ],
                          );
                        }),
                  );
                else
                  return Container(
                    child: Center(

                    ),
                  );
              })),
    );
  }
}
