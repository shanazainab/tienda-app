import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tienda/bloc/bottom-nav-bar-bloc.dart';
import 'package:tienda/bloc/events/bottom-nav-bar-events.dart';
import 'package:tienda/bloc/events/login-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/model/login-verify-request.dart';
import 'package:tienda/view/home/home-screen.dart';
import 'package:tienda/view/login/customer-details-page.dart';

import '../../localization.dart';

class OTPVerificationPage extends StatefulWidget {
  final String mobileNumber;

  OTPVerificationPage({this.mobileNumber});

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage>
    with CodeAutoFill {
  final StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  final TextEditingController textEditingController =
      new TextEditingController();

  String otp;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginStates>(
        listener: (context, state) {
          if (state is LoginVerifyOTPSuccess) {
            if (state.isNewUser) {
              ///Record Sign Up method
              FirebaseAnalytics().logSignUp(signUpMethod: "PHONE-NUMBER");

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerDetailsPage(
                          mobileNumber: widget.mobileNumber,
                        )),
              );
            } else {
              BlocProvider.of<BottomNavBarBloc>(context)
                  .add(ChangeBottomNavBarState(0, false));
              BlocProvider.of<LoginBloc>(context)..add(CheckLoginStatus());
              Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }
          } else if (state is LoginVerifyOTPError) {
            errorController.add(ErrorAnimationType.shake);

          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 0,
            title: Text("Verification code",
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  color: Color(0xff282828),
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0,
                )),
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
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 16.0, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                          "Please type verification code sent  to ${widget.mobileNumber}",
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            color: Color(0xff000000),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0,
                          ))),
                  SizedBox(
                    height: 20,
                  ),

                  ///OTP Pin enter field
                  SizedBox(
                    width: 150,
                    child: PinCodeTextField(
                      length: 4,
                      textInputType: TextInputType.number,
                      autoFocus: true,
                      obsecureText: false,
                      animationType: AnimationType.fade,

                      textStyle: TextStyle(
                        fontFamily: 'NunitoSans',
                        color: Color(0xff000000),
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0,
                      ),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 40,
                        fieldWidth: 33,
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

                  ///Verify button

                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ButtonTheme(
                      height: 44,
                      minWidth: MediaQuery.of(context).size.width - 120,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        color: otp?.length != 4
                            ? Colors.grey[200]
                            : Color(0xff2cdab3),
                        onPressed: () {
                          handleVerify();
                        },
                        child: Text("Verify",
                            style: TextStyle(
                              color:
                                  otp == null ? Colors.grey : Color(0xfff6f6f6),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0,
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    errorController.close();
    super.dispose();
  }

  @override
  void codeUpdated() {
    textEditingController.text = code;
  }

  void handleVerify() {
    if (textEditingController.text.length != 4) {
      errorController.add(ErrorAnimationType.shake);

      Fluttertoast.showToast(
          msg: "Enter Valid OTP",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      textEditingController.clear();
    } else
      BlocProvider.of<LoginBloc>(context).add(VerifyOTP(
          loginVerifyRequest: new LoginVerifyRequest(
              mobileNumber: widget.mobileNumber, otp: otp)));
  }
}
