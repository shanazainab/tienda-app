import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tienda/bloc/events/login-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/controller/login-controller.dart';
import 'package:tienda/view/home/tienda-home-page.dart';
import 'package:tienda/view/home/home-page.dart';
import 'package:tienda/view/login/login-mobile-number-page.dart';

class LoginMainPage extends StatelessWidget {
  final LoginController loginController = new LoginController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginStates>(
        listener: (context, state) {
          if (state is GoogleSignInResponse && state.response == GoogleSignInResponse.SUCCESS) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage()),
            );
          } else if (state is GoogleSignInResponse && state.response == GoogleSignInResponse.FAILED) {
            Fluttertoast.showToast(
                msg: "Something Went Wrong!!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        child: Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginWithMobileNumber()),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.mobileAlt,
                      size: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text("Continue With Phone Number"),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2,
              ),
              RaisedButton(
                onPressed: () {
                  BlocProvider.of<LoginBloc>(context).add(DoGoogleSignIn());
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.google,
                      size: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text("Continue With Google"),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2,
              ),
              RaisedButton(
                onPressed: () {
                  BlocProvider.of<LoginBloc>(context).add(DoFacebookSignIn());
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.facebook,
                      size: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text("Continue With facebook"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
