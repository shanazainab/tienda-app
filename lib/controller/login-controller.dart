import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/api/customer-profile-api-client.dart';
import 'package:tienda/api/login-api-client.dart';
import 'package:tienda/model/customer.dart';
import 'package:tienda/model/login-request.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/login-verify-request.dart';

class LoginController {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;
  final FlutterSecureStorage _secureStorage;

  LoginController(
      {FirebaseAuth firebaseAuth,
      FacebookLogin facebookLogin,
      GoogleSignIn googleSignin,
      FlutterSecureStorage secureStorage})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _facebookLogin = facebookLogin ?? FacebookLogin(),
        _googleSignIn = googleSignin ?? GoogleSignIn(),
        _secureStorage = secureStorage ?? FlutterSecureStorage();

  Future<String> signWithMobileNumber(LoginRequest loginRequest) async {
    String status;

    final dio = Dio();
    final client = LoginApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.sendOTP(loginRequest).then((response) {
      print("#########");
      print("LOGIN-SEND-OTP-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 201:
          status = "success";
          break;
        case 407:
          status = "Enter Valid Number";
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        print('%%%%%%%%%');
        print("LOGIN-SEND-OTP-ERROR:${error.response}");

        print("LOGIN-SEND-OTP-ERROR:${error.response?.data}");
        print('%%%%%REQUEST%%%%');

        print("LOGIN-SEND-OTP-ERROR:${error.request?.data}");
      }
    });

    return status;
  }

  Future<String> verifyLoginOTP(LoginVerifyRequest loginVerifyRequest) async {
    String status;

    final dio = Dio();
    dio.options.headers["Demo-Header"] = "demo header";
    final client = LoginApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.verifyOTP(loginVerifyRequest).then((response) async {
      print("#########");
      print("LOGIN-VERIFY-OTP-RESPONSE:$response");

      String body = response['body'];
      switch (json.decode(body)['status']) {
        case 200:
          status =
              json.decode(body)['registered'] ? "Existing User" : "New User";
          await _secureStorage.write(
              key: "session-id", value: response['headers']['set-cookie'][0]);

          String value = await _secureStorage.read(key: "session-id");

          print(":::COOKIE:::$value");
          break;
        case 400:
          status = "Enter Valid OTP";
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        print('%%%%%%%%%');
        print("LOGIN-VERIFY-OTP-ERROR:${error}");
        print('%%%%%REQUEST%%%%');

        print("LOGIN-VERIFY-OTP-ERROR:${error.request.data}");
      }
    });

    return status;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      if (credential != null)
        await _firebaseAuth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _firebaseAuth.currentUser();

      print("######## FIREBASE PROVIDER ID: ${currentUser.providerId}");

      ///Connect with tienda session id
      connectWithSession(googleAuth.accessToken);

      return currentUser;
    } else {
      ///User clicked on the google sign in cancel button

      return null;
    }
  }

  Future<FirebaseUser> signInWithFacebook() async {
    final result = await _facebookLogin.logIn(['email']);

    if (result.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      );

      final FirebaseUser user =
          (await _firebaseAuth.signInWithCredential(credential)).user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      final FirebaseUser currentUser = await _firebaseAuth.currentUser();

      print("######## FIREBASE PROVIDER ID: ${currentUser.providerId}");

      ///Connect with tienda session id
      connectWithSession(result.accessToken.token);

      return currentUser;
    } else {
      ///User clicked cancel for facebook login
      return null;
    }
  }

  Future<void> signWithFirebase() {
    ///TODO: firebase sign in with custom token
    ///Sign to firebase for users logged in with phone number
    return _firebaseAuth.currentUser();
  }

  Future<void> signOut() async {
    final FirebaseUser currentUser = await _firebaseAuth.currentUser();

    for (final userInfo in currentUser.providerData) {
      print("######## FIREBASE USER PROVIDER ID: ${userInfo.providerId}");
    }
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn?.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();

    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }

  registerCustomer(Customer customer) async {
    String status;

    final dio = Dio();
    String value = await _secureStorage.read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = CustomerProfileApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.registerCustomerDetails(customer).then((response) {
      print("#########");
      print("REGISTER-CUSTOMER-RESPONSE:$response");
      /* switch (json.decode(response)['status']) {
        case 201:
          status = "success";
          break;
        case 407:
          status = "Enter Valid Number";
      }*/
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        print('%%%%%%%%%');
        print("REGISTER-CUSTOMER-ERROR:${error.response}");

        print("REGISTER-CUSTOMER-ERROR-DATA:${error.response?.data}");
        print('%%%%%REQUEST%%%%');

        print("REGISTER-CUSTOMER-REQUEST:${error.request?.data}");
      }
    });

    return status;
  }

  void connectWithSession(String accessToken) {}
}
