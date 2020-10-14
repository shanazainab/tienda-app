import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-country.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/events/login-events.dart';
import 'package:tienda/bloc/events/preference-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/preference-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/preference-states.dart';
import 'package:tienda/model/country.dart';
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

  PreferenceBloc preferenceBloc = new PreferenceBloc();

  bool _showTick = false;

  Country country;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preferenceBloc.add(FetchCountryList());
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
              title: Text("Phone validation",
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
            body: BlocBuilder<PreferenceBloc, PreferenceStates>(
                cubit: preferenceBloc,
                builder: (context, state) {
                  if (state is LoadCountryListSuccess)
                    return Container(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 50, left: 16.0, right: 16),
                        child: Column(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("Enter your mobile number",
                                    style: TextStyle(
                                      color: Color(0xff484848),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0,
                                    ))),
                            SizedBox(
                              height: 20,
                            ),
                            ListTile(
                                leading: Container(
                                  width: 105,
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: <Widget>[
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton<Country>(
                                          value: country == null?appCountry.chosenCountry:country,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 24,
                                          elevation: 0,
                                          onChanged: (Country newValue) {
                                            setState(() {
                                              country = newValue;
                                            });
                                          },

                                          style: TextStyle(
                                            color: Color(0xde000000),
                                            fontSize: 19,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: 0,
                                          ),
                                          items: state.countries
                                              .map<DropdownMenuItem<Country>>(
                                                  (Country value) {
                                            return DropdownMenuItem<Country>(
                                              value: value,
                                              child: Row(
                                                children: [
                                                  Image.network(
                                                    "${GlobalConfiguration().getString("imageURL")}${value.thumbnail}",
                                                    width: 25,
                                                    height: 15,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text('+ ${value.countryCode}',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xde000000),
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        letterSpacing: 0,
                                                      )),
                                                ],
                                              ),
                                            );
                                          }).toList(),
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
                                    color: Color(0xff2cdab3),
                                  ),
                                )),
                            Divider(color: Color(0xff2cdab3), thickness: 2),
                            SizedBox(
                              height: 50,
                            ),
                            ButtonTheme(
                              height: 44,
                              minWidth: MediaQuery.of(context).size.width - 120,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                color: mobileNumberTextController.text.length != 9
                                    ? Colors.grey[200]
                                    : Color(0xff2cdab3),
                                onPressed: () {
                                  handleLogin(appCountry);
                                },
                                child: Text("Confirm",
                                    style: TextStyle(
                                      color:  mobileNumberTextController.text.length != 9?Colors.grey:Color(0xfff6f6f6),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0,

                                    )
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    );
                  else
                    return Container(
                      height: 0,
                    );
                })));
  }

  void handleLogin(AppCountry appCountry) {
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

    if(country == null)
      country = appCountry.chosenCountry;
    BlocProvider.of<LoginBloc>(context).add(SendOTP(
        loginRequest: new LoginRequest(
            mobileNumber: "+${country.countryCode}" +
                mobileNumberTextController.text)));
  }
}
