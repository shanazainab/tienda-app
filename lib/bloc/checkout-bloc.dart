import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/cart-api-client.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/states/checkout-states.dart';
import 'package:dio/dio.dart';

class CheckOutBloc extends Bloc<CheckoutEvents, CheckoutStates> {
  @override
  CheckoutStates get initialState => Loading();

  @override
  Stream<CheckoutStates> mapEventToState(CheckoutEvents event) async* {
    if (event is DoCartCheckout) {
      yield* _mapDoCardCheckoutToStates(event);
    }
  }

  Stream<CheckoutStates> _mapDoCardCheckoutToStates(
      DoCartCheckout event) async* {
    String status;

    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client =
    CartApiClient(dio, baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.cartCheckout(event.addressId).then((response) {
      Logger().d("CART-CEHCKOUT-RESPONSE:$response");
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
        Logger().e("CART-CEHCKOUT-ERROR:", error);
      }
    });

    if(status == "success")
      yield InitialCheckOutSuccess();



  }
}