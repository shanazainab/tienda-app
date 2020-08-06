import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/events/customer-profile-events.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/customer.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';
import 'package:tienda/view/widgets/image-option-dialogue.dart';

class EdiCustomerProfilePage extends StatefulWidget {
  final Customer customer;

  EdiCustomerProfilePage(this.customer);

  @override
  _EdiCustomerProfilePageState createState() => _EdiCustomerProfilePageState();
}

class _EdiCustomerProfilePageState extends State<EdiCustomerProfilePage> {
  final _formKey = GlobalKey<FormState>();

  File _image;
  final TextEditingController customerNameController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerProfileBloc, CustomerProfileStates>(
      listener: (context, state) {
        if (state is EditCustomerProfileSuccess) {
          Fluttertoast.showToast(
              msg: "Profile Updated", gravity: ToastGravity.BOTTOM);
        }
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
            if (state is LoadCustomerProfileSuccess)
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
                                          selectedImage: (image) async {
                                            print("CHOSEN IMAGE IS:$image");

                                            _image =
                                                await getCompressedFile(image);

                                            BlocProvider.of<
                                                CustomerProfileBloc>(context)
                                              ..add(UpdateProfilePicture(
                                                  widget.customer, _image));
                                            setState(() {});
                                          },
                                        );
                                      });
                                },
                                child: state.customerDetails.profileImage ==
                                        null
                                    ? CircleAvatar(
                                        radius: 75,
                                        backgroundColor: Color(0xfff2f2e4),
                                        backgroundImage: _image != null
                                            ? FileImage(_image)
                                            : null,
                                      )
                                    : CircleAvatar(
                                        radius: 75,
                                        backgroundColor: Color(0xfff2f2e4),
                                        backgroundImage: NetworkImage(
                                            "${GlobalConfiguration().getString("baseURL")}/${state.customerDetails.profileImage}"))),
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
                        padding: const EdgeInsets.only(
                            left: 24.0, right: 24.0, top: 24),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              initialValue: widget.customer.name,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Enter your name";
                                }
                                widget.customer.name = value;
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
                                  if (_formKey.currentState.validate()) {
                                    Logger().d(
                                        "CUSTOMER NAME:${widget.customer.name}");

                                    BlocProvider.of<CustomerProfileBloc>(
                                        context)
                                      ..add(EditCustomerProfile(
                                          customer: widget.customer));
                                  }
                                },
                                child: Text(AppLocalizations.of(context)
                                    .translate('save')),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            else
              return Container();
          })),
    );
  }

  Future<File> getCompressedFile(File image) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File compressedImage = new File("$tempPath/image.jpg");

    ///compress image
    var result = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      compressedImage.absolute.path,
      quality: 50,
    );

    print(image.lengthSync());
    print(result.lengthSync());

    return result;
  }
}
