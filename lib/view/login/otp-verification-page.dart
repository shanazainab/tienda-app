import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tienda/bloc/events/login-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/model/login-verify-request.dart';
import 'package:tienda/view/home/main-page.dart';
import 'package:tienda/view/login/customer-details-page.dart';

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
            if (state.isNewUser)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerDetailsPage(
                          mobileNumber: widget.mobileNumber,
                        )),
              );
            else
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
              );
          } else if (state is LogoutError) {
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
              padding: const EdgeInsets.only(top: 100, left: 16.0, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ///OTP Pin enter field
                  PinCodeTextField(
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

                  ///Verify button

                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: RaisedButton(
                      color: otp?.length != 4 ? Colors.grey : Colors.black,
                      onPressed: () {
                        handleVerify();
                      },
                      child: Text("VERIFY"),
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
