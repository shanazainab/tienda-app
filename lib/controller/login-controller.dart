import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
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
        case 200:
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

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    String status = "failed";
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
      status = await connectGoogleAccountWithSession(googleAuth?.idToken);

      return status;
    } else {
      ///User clicked on the google sign in cancel button
      status = "cancelled";
      return status;
    }
  }

  Future<String> signInWithFacebook() async {
    String status;

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
      status =
          await connectFacebookAccountWithSession(result.accessToken.token);

      return status;
    } else {
      ///User clicked cancel for facebook login
      status = "cancelled";
      return status;
    }
  }

  Future<void> signWithFirebase() {
    ///TODO: firebase sign in with custom token
    ///Sign to firebase for users logged in with phone number
    return _firebaseAuth.currentUser();
  }

  Future<String> logOut() async {
    final FirebaseUser currentUser = await _firebaseAuth.currentUser();

    /*for (final userInfo in currentUser.providerData) {
      print("######## FIREBASE USER PROVIDER ID: ${userInfo.providerId}");
    }*/
    String status;

    final dio = Dio();
    String value = await _secureStorage.read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = LoginApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.logout().then((response) async {
      print("#########");
      print("LOGOUT-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          await _secureStorage.delete(key: "session-id");
          status = "success";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        print('%%%%%%%%%');
        print("LOGOUT-DIO-RESPONSE-ERROR:$error");
        print("LOGOUT-DIO-REQUEST:${error.request.data}");
      } else {
        print("LOGOUT-ERROR:$err");
      }
      status = "failed";
    });
    await _firebaseAuth.signOut();
    await _googleSignIn?.signOut();
    return status;
  }

  Future<bool> checkLoginStatus() async {
    final currentUser = await _firebaseAuth.currentUser();

    bool isLoggedIn = false;

    String sessionId = await _secureStorage.read(key: "session-id");

    if (sessionId == null) {
      ///Not a logged in customer
      ///check guest session-id
      String guestSessionId =
          await _secureStorage.read(key: "guest-session-id");

      if (guestSessionId == null) {
        ///First time users
        ///Get a guest session id

        final dio = Dio();
        final client = LoginApiClient(dio,
            baseUrl: GlobalConfiguration().getString("baseURL"));

        String deviceId = await getDeviceId();
        await client.getGuestLoginSessionId(deviceId).then((response) async {
          print("#########");
          print("GUEST-LOGIN-SESSION-RESPONSE:$response");
          print("#########");
          String body = response['body'];
          switch (json.decode(body)['status']) {
            case 200:
              await _secureStorage.write(
                  key: "guest-session-id",
                  value: response['headers']['set-cookie'][0]);

              String guestSessionId =
                  await _secureStorage.read(key: "guest-session-id");
              print("GUEST-LOGIN-SESSION-ID:$guestSessionId");

              break;
            default:
              break;
          }
        }).catchError((err) {
          if (err is DioError) {
            DioError error = err;
            print('%%%%%%%%%');
            print("GUEST-LOGIN-SESSION-ERROR:${error.response}");
            print("REGISTER-CUSTOMER-ERROR-DATA:${error.response?.data}");
            print("REGISTER-CUSTOMER-REQUEST:${error.request?.data}");
            print('%%%%%%%%%');
          }
        });
      } else {

        print("GUEST CUSTOMER");
      }
    } else {
      print("REGISTERED CUSTOMER");
      isLoggedIn = true;
    }
    if(currentUser != null) isLoggedIn = true;
    return isLoggedIn;
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

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String deviceId;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}');
      deviceId = androidInfo.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}');
      deviceId = iosInfo.identifierForVendor;
    }

    return deviceId;
  }

  Future<String> connectGoogleAccountWithSession(String accessToken) async {
    String status;

    final dio = Dio();
    final client = LoginApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.checkGoogleToken(accessToken).then((response) async {
      print("#########");

      print("GOOGLE-TOKEN-RESPONSE:$response");

      String body = response['body'];
      switch (json.decode(body)['status']) {
        case 200:
          await _secureStorage.write(
              key: "session-id", value: response['headers']['set-cookie'][0]);

          String value = await _secureStorage.read(key: "session-id");

          print("SESSION ID FOR GOOGLE SIGN IN: $value");
          status = "success";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        print('%%%%%%%%%');
        print("GOOGLE-TOKEN-ERROR:${error.response}");

        print("GOOGLE-TOKEN-ERROR:${error.response?.data}");
        print('%%%%%REQUEST%%%%');

        print("GOOGLE-TOKEN-ERROR:${error.request?.data}");
        status = "failed";
      }
    });

    return status;
  }

  Future<String> connectFacebookAccountWithSession(String token) async {
    String status;

    final dio = Dio();
    final client = LoginApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.checkFacebookToken(token).then((response) async {
      print("#########");
      print("FACEBOOK-TOKEN-RESPONSE:$response");
      String body = response['body'];
      switch (json.decode(body)['status']) {
        case 200:
          await _secureStorage.write(
              key: "session-id", value: response['headers']['set-cookie'][0]);

          String value = await _secureStorage.read(key: "session-id");

          print("SESSION ID FOR FACEBOOK SIGN IN: $value");
          status = "success";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        print('%%%%%%%%%');
        print("FACEBOOK-TOKEN-ERROR:${error.response}");

        print("FACEBOOK-TOKEN-ERROR:${error.response?.data}");
        print('%%%%%REQUEST%%%%');

        print("FACEBOOK-TOKEN-ERROR:${error.request?.data}");
        status = "failed";
      }
    });

    return status;
  }
}
