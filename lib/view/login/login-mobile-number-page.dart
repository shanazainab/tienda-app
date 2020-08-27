import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-country.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/events/login-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/model/login-request.dart';
import 'package:tienda/view/login/otp-verification-page.dart';

import '../../localization.dart';

class LoginWithMobileNumber extends StatefulWidget {
  @override
  _LoginWithMobileNumberState createState() => _LoginWithMobileNumberState();
}

class _LoginWithMobileNumberState extends State<LoginWithMobileNumber> {
  TextEditingController mobileNumberTextController =
      new TextEditingController();

  bool _showTick = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mobileNumberTextController.addListener(() {
      if (mobileNumberTextController.text.length == 9) {
        setState(() {
          _showTick = true;
        });
        FocusScope.of(context).requestFocus(FocusNode());
      } else {
        setState(() {
          _showTick = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    var appCountry = Provider.of<AppCountry>(context);

    return BlocListener<LoginBloc, LoginStates>(
        listener: (context, state) {
          if (state is LoginSendOTPSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPVerificationPage(
                        mobileNumber: "+971" + mobileNumberTextController.text,
                      )),
            );
          } else if (state is LoginSendOTPError) {
            Fluttertoast.showToast(
                msg: state.error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            brightness: Brightness.light,
            elevation: 0,
          ),
          bottomNavigationBar:
              BlocBuilder<LoginBloc, LoginStates>(builder: (context, state) {
            if (state is LoginInProgress)
              return LinearProgressIndicator();
            else
              return Container(
                height: 0,
              );
          }),
          body: Container(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 16.0, right: 16),
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        AppLocalizations.of(context).translate('enter-your-mobile-number'),
                        style: TextStyle(fontSize: 20),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                      leading: Container(
                        width: 70,
                        alignment: Alignment.center,
                        child: Row(
                          children: <Widget>[
                            Image.network(
                              "${GlobalConfiguration().getString("imageURL")}${appCountry.chosenCountry.thumbnail}",
                              width: 25,
                              height: 15,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "+ ${appCountry.chosenCountry.countryCode}",
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: new TextFormField(
                          controller: mobileNumberTextController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: new InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.all(0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      trailing: Visibility(
                        visible: _showTick,
                        child: Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                      )),
                  Divider(color: Colors.grey[200], thickness: 2),
                  SizedBox(
                    height: 16,
                  ),
                  RaisedButton(
                    color: mobileNumberTextController.text.length != 9
                        ? Colors.grey
                        : Colors.black,
                    onPressed: () {
                      handleLogin(appCountry);
                    },
                    child: Text( AppLocalizations.of(context).translate('next')),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void handleLogin(appCountry) {
    /*if(mobileNumberTextController.text.length != 10){
         Fluttertoast.showToast(
                  msg: "Enter Valid Mobile Number",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
    }
    else
    _loginBloc.add(SendOTP(
        loginRequest: new LoginRequest(
            mobileNumber: "+971" + mobileNumberTextController.text)));*/

    FocusScope.of(context).requestFocus(FocusNode());

    BlocProvider.of<LoginBloc>(context).add(SendOTP(
        loginRequest: new LoginRequest(
            mobileNumber: "+${appCountry.chosenCountry.countryCode}" +
                mobileNumberTextController.text)));
  }
}
