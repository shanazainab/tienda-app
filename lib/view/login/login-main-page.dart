import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tienda/bloc/bottom-nav-bar-bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/events/bottom-nav-bar-events.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/customer-profile-events.dart';
import 'package:tienda/bloc/events/login-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/controller/login-controller.dart';
import 'package:tienda/view/home/page/main-screen.dart';
import 'package:tienda/view/login/login-mobile-number-page.dart';
import 'package:tienda/view/widgets/loading-widget.dart';

import '../../localization.dart';

class LoginMainPage extends StatelessWidget {
  final LoginController loginController = new LoginController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginStates>(
        listener: (context, state) {
          if (state is GoogleSignInResponse &&
              state.response == GoogleSignInResponse.SUCCESS) {

           ///Sequence task to be done after successful login
            BlocProvider.of<BottomNavBarBloc>(context)
                .add(ChangeBottomNavBarState(0, false));
            BlocProvider.of<LoginBloc>(context)..add(CheckLoginStatus());
            BlocProvider.of<CartBloc>(context)..add(FetchCartData());
            BlocProvider.of<CustomerProfileBloc>(context)
              ..add(FetchCustomerProfile());
            ///

            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (context) => MainScreen()));
          } else if (state is GoogleSignInResponse &&
              state.response == GoogleSignInResponse.FAILED) {
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
          appBar: AppBar(
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
          ),
          bottomNavigationBar:
              BlocBuilder<LoginBloc, LoginStates>(builder: (context, state) {
            if (state is SocialAccountLoginProgress)
              return linearProgress;
            else
              return Container(
                height: 0,
              );
          }),
          body: Stack(
            children: <Widget>[
              Container(
                child: Text(""),
              ),
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginWithMobileNumber()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
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
                                child: Text(AppLocalizations.of(context)
                                    .translate('continue-with-phone-number')),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context)
                              .add(DoGoogleSignIn());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
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
                                child: Text(AppLocalizations.of(context)
                                    .translate('continue-with-google')),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context)
                              .add(DoFacebookSignIn());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
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
                                child: Text(AppLocalizations.of(context)
                                    .translate('continue-with-facebook')),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
