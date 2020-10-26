import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/edit-customer-profile-bloc.dart';
import 'package:tienda/bloc/events/customer-profile-events.dart';
import 'package:tienda/bloc/events/loading-events.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';
import 'package:tienda/bloc/states/loading-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/customer.dart';
import 'package:tienda/view/widgets/image-option-dialogue.dart';

class EdiCustomerProfilePage extends StatefulWidget {
  final Customer customer;

  EdiCustomerProfilePage(this.customer);

  @override
  _EdiCustomerProfilePageState createState() => _EdiCustomerProfilePageState();
}

class _EdiCustomerProfilePageState extends State<EdiCustomerProfilePage> {
  final _formKeyName = GlobalKey<FormState>();
  final _formKeyPhoneNumber = GlobalKey<FormState>();

  LoadingBloc nameUpdateLoading = new LoadingBloc();

  LoadingBloc phoneUpdateLoading = new LoadingBloc();

  String otp;

  final StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  final EditCustomerProfileBloc editCustomerProfileBloc =
      new EditCustomerProfileBloc();
  final TextEditingController textEditingController =
      new TextEditingController();

  File _image;
  final TextEditingController customerNameController =
      new TextEditingController();

  bool isPhoneLogin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLoginType();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<CustomerProfileBloc, CustomerProfileStates>(
              listener: (context, state) {
            if (state is LoadCustomerProfileSuccess)
              BlocProvider.of<LoadingBloc>(context)..add(StopLoading());
          }),
          BlocListener<EditCustomerProfileBloc, CustomerProfileStates>(
            cubit: editCustomerProfileBloc,
            listener: (context, state) {
              if (state is VerifyPhoneNumberSuccess)
                phoneUpdateLoading.add(StopLoading());
              if (state is ChangePhoneNumberSuccess)
                phoneUpdateLoading.add(StopLoading());
            },
          ),
        ],
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                "PROFILE DETAILS",
              ),
              brightness: Brightness.light,
              centerTitle: false,
            ),
            body: BlocBuilder<CustomerProfileBloc, CustomerProfileStates>(
                builder: (_, state) {
              if (state is LoadCustomerProfileSuccess)
                return customerDetailsForm(state.customerDetails);
              else
                return Container();
            })));
  }

  customerDetailsForm(Customer customerDetails) {
    return Column(
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
                                BlocProvider.of<LoadingBloc>(context)
                                  ..add(StartLoading());
                                print("CHOSEN IMAGE IS:$image");

                                _image = await getCompressedFile(image);
                                BlocProvider.of<CustomerProfileBloc>(context)
                                  ..add(UpdateProfilePicture(
                                      widget.customer, _image));
                              },
                            );
                          });
                    },
                    child: CircleAvatar(
                        radius: 75,
                        backgroundColor: Color(0xfff2f2e4),
                        child: BlocBuilder<LoadingBloc, LoadingStates>(
                            builder: (context, loadingState) {
                          if (loadingState is AppLoading)
                            return CircularProgressIndicator(
                              strokeWidth: 2,
                            );
                          return Container();
                        }),
                        backgroundImage: NetworkImage(
                            "${GlobalConfiguration().getString("imageURL")}/${customerDetails.profilePicture}"))),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Icon(Icons.add_a_photo))
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(
                left: 24.0, right: 24.0, top: 24, bottom: 100),
            children: <Widget>[
              Container(
                height: 40,
                alignment: Alignment.centerLeft,
                color: Colors.pink.withOpacity(0.1),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("BIO"),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                initialValue: widget.customer.fullName,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter your name";
                  }
                  widget.customer.fullName = value;
                  return null;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelText: AppLocalizations.of(context).translate('name')),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      if (_formKeyName.currentState.validate()) {
                        Logger().d("CUSTOMER NAME:${widget.customer.fullName}");

                        BlocProvider.of<CustomerProfileBloc>(context)
                          ..add(EditCustomerProfile(customer: widget.customer));
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('save'),
                      style: TextStyle(
                          color: Color(0xFF50c0a8),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 40,
                alignment: Alignment.centerLeft,
                color: Colors.pink.withOpacity(0.1),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("CONTACT"),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              isPhoneLogin == null
                  ? Container()
                  : isPhoneLogin
                      ? Form(
                          key: _formKeyPhoneNumber,
                          child: TextFormField(
                              validator: (value) {
                                Pattern pattern =
                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                    r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                    r"{0,253}[a-zA-Z0-9])?)*$";
                                RegExp regex = new RegExp(pattern);
                                if (value.isEmpty) {
                                  return "Enter your email";
                                }
                                if (!regex.hasMatch(value) || value == null)
                                  return 'Enter a valid email address';
                                widget.customer.email = value;
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  labelText: AppLocalizations.of(context)
                                      .translate('email'))),
                        )
                      : Form(
                          key: _formKeyPhoneNumber,
                          child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Enter mobile number";
                                }
                                if (value.length < 10) {
                                  return "Enter a valid mobile number";
                                }
                                widget.customer.phoneNumber = value;
                                return null;
                              },
                              initialValue: widget.customer.phoneNumber,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  labelText: 'Mobile Number')),
                        ),
              BlocBuilder<EditCustomerProfileBloc, CustomerProfileStates>(
                  cubit: editCustomerProfileBloc,
                  builder: (context, state) {
                    if (state is ChangePhoneNumberSuccess)
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Enter OTP sent to your mobile number"),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: PinCodeTextField(
                                length: 4,
                                textInputType: TextInputType.number,
                                autoFocus: true,
                                obsecureText: false,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.underline,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 40,
                                  inactiveColor: Colors.grey[200],
                                  activeColor: Colors.black,
                                  selectedColor: Colors.grey[200],
                                  activeFillColor: Colors.white,
                                ),
                                animationDuration: Duration(milliseconds: 300),
                                backgroundColor: Colors.white,
                                enableActiveFill: false,
                                autoDismissKeyboard: true,
                                errorAnimationController: errorController,
                                controller: textEditingController,
                                onCompleted: (v) {
                                  print("Completed");
                                  otp = v;
                                  setState(() {});
                                },
                                onChanged: (value) {
                                  print(value);
                                },
                                beforeTextPaste: (text) {
                                  print("Allowing to paste $text");
                                  return true;
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    else
                      return Container();
                  }),
              BlocBuilder<LoadingBloc, LoadingStates>(
                  cubit: phoneUpdateLoading,
                  builder: (context, state) {
                    if (state is AppLoading) {
                      return FlatButton(
                        onPressed: () {},
                        child: Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    } else {
                      return BlocBuilder<EditCustomerProfileBloc,
                              CustomerProfileStates>(
                          cubit: editCustomerProfileBloc,
                          builder: (context, state) {
                            if (state is ChangePhoneNumberSuccess) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: FlatButton(
                                      onPressed: () {
                                        phoneUpdateLoading.add(StartLoading());
                                        if (isPhoneLogin) {
                                          ///verify email

                                        } else if (!isPhoneLogin &&
                                            _formKeyPhoneNumber.currentState
                                                .validate()) {
                                          ///verify mobile number

                                          editCustomerProfileBloc
                                            ..add(VerifyPhoneNumber(
                                                phoneNumber:
                                                    widget.customer.phoneNumber,
                                                otp: otp));
                                        }
                                      },
                                      child: Text(
                                        "VERIFY",
                                        style: TextStyle(
                                            color: Color(0xFF50c0a8),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: FlatButton(
                                    onPressed: () {
                                      phoneUpdateLoading.add(StartLoading());

                                      if (isPhoneLogin) {
                                      } else if (!isPhoneLogin &&
                                          _formKeyPhoneNumber.currentState
                                              .validate()) {
                                        editCustomerProfileBloc
                                          ..add(ChangePhoneNumber(
                                              phoneNumber:
                                                  widget.customer.phoneNumber));
                                      }
                                    },
                                    child: Text(
                                      "CHANGE",
                                      style: TextStyle(
                                          color: Color(0xFF50c0a8),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              );
                            }
                          });
                    }
                  })
            ],
          ),
        ),
      ],
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

  Future<void> getLoginType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String loginType = sharedPreferences.getString('login-type');

    switch (loginType) {
      case 'phone':
        isPhoneLogin = true;
        break;
      case 'google':
      case 'facebook':
        isPhoneLogin = false;
        break;
    }

    setState(() {});
  }
}
