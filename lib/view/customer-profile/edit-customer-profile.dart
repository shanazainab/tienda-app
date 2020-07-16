import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/events/customer-profile-events.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/customer.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';
import 'package:tienda/view/widgets/image-option-dialogue.dart';

class EditCustomerProfilePage extends StatelessWidget {
  final Customer customer;
  final _imageStream = BehaviorSubject<File>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController customerNameController =
      new TextEditingController();

  EditCustomerProfilePage(this.customer);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerProfileBloc, CustomerProfileStates>(
      listener: (context, state) {
       if(state is EditCustomerProfileSuccess)
         Fluttertoast.showToast(
             msg: "Profile Updated",
             gravity: ToastGravity.BOTTOM);
      },
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(44),
              child: CustomAppBar(
                showLogo: false,
                showCart: true,
                showSearch: true,
                showWishList: true,
                title: AppLocalizations.of(context).translate('edit-profile'),
              )),
          body: BlocBuilder<CustomerProfileBloc, CustomerProfileStates>(
              builder: (_, state) {
            return Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 200,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              height: 140,
                              color: Colors.grey[200],
                            ),
                            Container(
                              height: 60,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext bc) {
                                    return ImageOptionDialogue(
                                      camera: null,
                                      selectedImage: (image) {
                                        print("CHOSEN IMAGE IS:$image");
                                        _imageStream.add(image);
                                      },
                                    );
                                  });
                            },
                            child: StreamBuilder<File>(
                                stream: _imageStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<File> snapshot) {
                                  return CircleAvatar(
                                    radius: 75,
                                    backgroundColor: Colors.lightBlue,
                                    backgroundImage: snapshot.data != null
                                        ? FileImage(snapshot.data)
                                        : null,
                                  );
                                }),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Icon(Icons.add_a_photo))
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 24.0, right: 24.0, top: 24),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            initialValue: customer.name,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter your name";
                              }
                              customer.name = value;
                              return null;
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[100],
                                labelText: AppLocalizations.of(context)
                                    .translate('name')),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: TextFormField(
                              enabled: false,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  labelText: AppLocalizations.of(context)
                                      .translate('email')),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: RaisedButton(
                              onPressed: () {


                                if(_formKey.currentState.validate()) {
                                  Logger().d("CUSTOMER NAME:${customer.name}");


                                  BlocProvider.of<CustomerProfileBloc>(context)
                                    ..add(EditCustomerProfile(
                                        customer: customer));
                                }
                              },
                              child: Text(
                                  AppLocalizations.of(context).translate('save')),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          })),
    );
  }
}
