import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tienda/controller/login-controller.dart';
import 'package:tienda/view/login/login-mobile-number-page.dart';

class LoginMainPage extends StatelessWidget {
  final LoginController loginController = new LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  loginController.signInWithGoogle();
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
                  loginController.signInWithFacebook();
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
    );
  }
}
