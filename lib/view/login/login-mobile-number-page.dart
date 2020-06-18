import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tienda/bloc/events/login-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/model/login-request.dart';
import 'package:tienda/view/login/otp-verification-page.dart';

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
      if (mobileNumberTextController.text.length == 10) {
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
              padding: const EdgeInsets.only(top: 100, left: 16.0, right: 16),
              child: Column(
                children: <Widget>[
                  ListTile(
                      leading: Container(
                        width: 70,
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              "assets/flags/ae.png",
                              height: 30,
                              width: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text("+971"),
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
                    color: mobileNumberTextController.text.length != 10
                        ? Colors.grey
                        : Colors.black,
                    onPressed: () {
                      handleLogin();
                    },
                    child: Text("NEXT"),
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

  void handleLogin() {
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

    BlocProvider.of<LoginBloc>(context).add(SendOTP(
        loginRequest: new LoginRequest(
            mobileNumber: "+971" + mobileNumberTextController.text)));
  }
}
