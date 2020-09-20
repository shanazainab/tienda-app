import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/cart-api-client.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/states/checkout-states.dart';
import 'package:dio/dio.dart';
import 'package:tienda/controller/real-time-controller.dart';

class CheckOutBloc extends Bloc<CheckoutEvents, CheckoutStates> {
  CheckOutBloc() : super(Loading());

  @override
  Stream<CheckoutStates> mapEventToState(CheckoutEvents event) async* {
    if (event is Initialize) {
      yield Loading();
    }
    if (event is DoCartCheckout) {
      yield* _mapDoCardCheckoutToStates(event);
    }
    if (event is DoUpdateCheckOutProgress) {
      if (event.status == "CART"){
        print("ORDER FROM CART: ${event.order.products}");
        yield CartActive(event.status, event.order);}
      else if (event.status == "ADDRESS"){
        print("ORDER FROM ADDRESS: ${event.order.products}");

        yield AddressActive(event.status, event.order);}
      else if (event.status == "PAYMENT"){
        print("ORDER FROM PAYMENT: ${event.order.products}");

        yield PaymentActive(event.status, event.order);}
    }
  }

  Stream<CheckoutStates> _mapDoCardCheckoutToStates(
      DoCartCheckout event) async* {
    String status;

    print("PAYMENT INITIATED");
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client =
        CartApiClient(dio, baseUrl: GlobalConfiguration().getString("baseURL"));
    print("PAYMENT INITIATED");

    await client
        .cartCheckout(
            event.order.addressId, event.card, event.cardId, event.cvv)
        .then((response) {
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
    print("PAYMENT INITIATED");

    if (status == "success") {
      ///do real time update for the checkout action

      if (event.fromLiveStream) {
        for (final product in event.order.products)
          RealTimeController()
              .emitCheckoutFromLive(product.id, event.presenterId);
      }

      yield InitialCheckOutSuccess();
    }
  }
}
