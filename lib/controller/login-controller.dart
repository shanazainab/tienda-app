import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/api/cart-api-client.dart';
import 'package:tienda/api/customer-profile-api-client.dart';
import 'package:tienda/api/login-api-client.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/model/customer.dart';
import 'package:tienda/model/login-request.dart';
import 'package:tienda/model/login-verify-request.dart';

class LoginController {
  LoginController._privateConstructor();

  static final LoginController _instance =
      LoginController._privateConstructor();

  factory LoginController() {
    return _instance;
  }

  Future<String> signWithMobileNumber(LoginRequest loginRequest) async {
    String status;

    final dio = Dio();
    final client = LoginApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.sendOTP(loginRequest).then((response) {
      Logger().d("LOGIN-SEND-OTP-RESPONSE:$response");
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
        Logger().e("LOGIN-SEND-OTP-ERROR", error);
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
      Logger().d("LOGIN-VERIFY-OTP-RESPONSE:$response");

      dynamic body = response['body'];
      switch (body['status']) {
        case 200:
          print("equal");

          status = body['registered'] ? "Existing User" : "New User";
          await FlutterSecureStorage().write(
              key: "session-id", value: response['headers']['set-cookie'][0]);

          ///initialize socket.io connection
          RealTimeController().initialize();
          callUpdateDeviceId();
          break;
        case 400:
          status = "Enter Valid OTP";
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("LOGIN-VERIFY-OTP-ERROR", error);
      }
    });

    print("status:   $status");
    return status;
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn().catchError((onError) {
      Logger().e(onError);
    });

    String status = "failed";
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      if (credential != null)
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .catchError((onError) {
          Logger().e(onError);
        });
      final FirebaseUser currentUser =
          await FirebaseAuth.instance.currentUser();

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

    final result = await FacebookLogin().logIn(['email']);

    if (result.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      );

      final FirebaseUser user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      final FirebaseUser currentUser =
          await FirebaseAuth.instance.currentUser();

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
    return FirebaseAuth.instance.currentUser();
  }

  Future<String> logOut() async {
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    /*for (final userInfo in currentUser.providerData) {
      print("######## FIREBASE USER PROVIDER ID: ${userInfo.providerId}");
    }*/
    String status;

    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = LoginApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.logout().then((response) async {
      Logger().d("LOGOUT-RESPONSE $response");
      switch (json.decode(response)['status']) {
        case 200:
          await FlutterSecureStorage().delete(key: "session-id");
          status = "success";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("LOGOUT-DIO-RESPONSE-ERROR:", error);
      } else {}
      status = "failed";
    });
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn()?.signOut();
    return status;
  }

  Future<bool> checkLoginStatus() async {
    //  final currentUser = await FirebaseAuth.instance.currentUser();

    bool isLoggedIn = false;

    String sessionId = await FlutterSecureStorage().read(key: "session-id");

    if (sessionId == null) {
      ///Not a logged in customer
      ///check guest session-id
      String guestSessionId =
          await FlutterSecureStorage().read(key: "guest-session-id");

      if (guestSessionId == null) {
        ///First time users
        ///Get a guest session id

        final dio = Dio();
        final client = LoginApiClient(dio,
            baseUrl: GlobalConfiguration().getString("baseURL"));

        String deviceId = await getDeviceId();
        await client.getGuestLoginSessionId(deviceId).then((response) async {
          Logger().d("GUEST-LOGIN-SESSION-RESPONSE:$response");
          String body = response['body'];
          switch (json.decode(body)['status']) {
            case 200:
              await FlutterSecureStorage().write(
                  key: "guest-session-id",
                  value: response['headers']['set-cookie'][0]);

              String guestSessionId =
                  await FlutterSecureStorage().read(key: "guest-session-id");
              Logger().d("GUEST-LOGIN-SESSION-ID:$guestSessionId");

              break;
            default:
              break;
          }
        }).catchError((err) {
          if (err is DioError) {
            DioError error = err;
            Logger().e("GUEST-LOGIN-SESSION-ERROR:", error);
          }
        });
      } else {
        print("GUEST CUSTOMER");
      }
    } else {
      Logger().d("REGISTERED CUSTOMER");

      isLoggedIn = true;
    }
//    if (currentUser != null) isLoggedIn = true;
    return isLoggedIn;
  }

  Future<String> getUser() async {
    return (await FirebaseAuth.instance.currentUser()).email;
  }

  registerCustomer(Customer customer) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('customer-name', customer.fullName);
    sharedPreferences.setString('customer', customerToJson(customer));
    String status;

    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = CustomerProfileApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.registerCustomerDetails(customer).then((response) {
      Logger().d("REGISTER-CUSTOMER-RESPONSE:$response");
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
        Logger().e("REGISTER-CUSTOMER-ERROR", error);
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
      Logger().d("GOOGLE-TOKEN-RESPONSE:$response");

      switch (response['body']['status']) {
        case 200:
          await FlutterSecureStorage().write(
              key: "session-id", value: response['headers']['set-cookie'][0]);

          String value = await FlutterSecureStorage().read(key: "session-id");

          print("SESSION ID FOR GOOGLE SIGN IN: $value");
          status = "success";

          ///initialize socket.io connection
          RealTimeController().initialize();

          callUpdateDeviceId();
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;

        Logger().e("GOOGLE-TOKEN-ERROR:", error);
        Logger().e("GOOGLE-TOKEN-ERROR:", error.request.data);

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
      dynamic body = response['body'];
      switch (json.decode(body)['status']) {
        case 200:
          await FlutterSecureStorage().write(
              key: "session-id", value: response['headers']['set-cookie'][0]);

          String value = await FlutterSecureStorage().read(key: "session-id");

          Logger().d("SESSION ID FOR FACEBOOK SIGN IN: $value");
          status = "success";

          ///initialize socket.io connection
          RealTimeController().initialize();
          callUpdateDeviceId();

          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("FACEBOOK-TOKEN-ERROR:", error);
        status = "failed";
      }
    });

    return status;
  }

  callAddToCartApi(productId, quantity) {
    final dio = Dio();
    final client =
        CartApiClient(dio, baseUrl: GlobalConfiguration().getString("baseURL"));
    client.addToCart(productId, quantity).then((response) {
      Logger().d("ADD-TO-CART-AFTER-LOGIN-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          break;
        case 407:
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("ADD-TO-CART-AFTER-LOGIN-ERROR:", error);
      }
    });
  }

  Future<void> checkCookie() async {
    String status;

    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = LoginApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.checkCookie().then((response) {
      Logger().d("CHECK-COOKIE-RESPONSE:$response");
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
        Logger().e("LOGIN-SEND-OTP-ERROR:", error);
      }
    });

    return status;
  }

  Future<String> callUpdateDeviceId() async {
    String status;

    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = LoginApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));

    String deviceId = await _getId();
    await client.updateDeviceId(deviceId).then((response) {
      Logger().d("UPDATE-DEVICE-ID-RESPONSE:$response");
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
        Logger().e("UPDATE-DEVICE-ID-ERROR:", error);
      }
    });

    return status;
  }

  Future<String> _getId() async {
    OSPermissionSubscriptionState subscriptionState =
        await OneSignal.shared.getPermissionSubscriptionState();
    Logger().d("PLAYER ID: ${subscriptionState.subscriptionStatus.userId}");

    return subscriptionState.subscriptionStatus.userId;
//    var deviceInfo = DeviceInfoPlugin();
//    if (Platform.isIOS) {
//      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
//      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
//    } else {
//      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
//      return androidDeviceInfo.androidId; // unique ID on Android
//    }
  }
}
