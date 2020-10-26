import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/cart-api-client.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/states/checkout-states.dart';
import 'package:tienda/controller/real-time-controller.dart';

class CheckOutBloc extends Bloc<CheckoutEvents, CheckoutStates> {
  CheckOutBloc() : super(DoCartCheckoutUpdateSuccess(checkOutStatus: 'CART'));

  @override
  Stream<CheckoutStates> mapEventToState(CheckoutEvents event) async* {
    if (event is DoCartCheckoutProgressUpdate) {
      yield* _mapDoCardCheckoutToStates(event);
    }
  }

  Stream<CheckoutStates> _mapDoCardCheckoutToStates(
      DoCartCheckoutProgressUpdate event) async* {
    if (event.checkOutStatus == 'CART') {
      yield DoCartCheckoutUpdateSuccess(
          presenterId: event.presenterId,
          fromLiveStream: event.fromLiveStream,
          checkOutStatus: event.checkOutStatus,
          deliveryAddress: event.deliveryAddress,
          card: event.card);
    } else if (event.checkOutStatus == 'ADDRESS') {
      yield DoCartCheckoutUpdateSuccess(
          presenterId: event.presenterId,
          fromLiveStream: event.fromLiveStream,
          checkOutStatus: event.checkOutStatus,
          deliveryAddress: event.deliveryAddress,
          card: event.card);
    } else if (event.checkOutStatus == "PAYMENT") {
      yield DoCartCheckoutUpdateSuccess(
          presenterId: event.presenterId,
          fromLiveStream: event.fromLiveStream,
          deliveryAddress: event.deliveryAddress,
          checkOutStatus: event.checkOutStatus,
          card: event.card);
    } else if (event.checkOutStatus == "PROCESS-PAYMENT") {
      String status = await callCheckOutApi(event);

      if (status == "success")
        yield DoCartCheckoutUpdateSuccess(
            presenterId: event.presenterId,
            deliveryAddress: event.deliveryAddress,
            fromLiveStream: event.fromLiveStream,
            checkOutStatus: 'SUCCESS',
            card: event.card);
      else
        yield DoCartCheckoutUpdateSuccess(
            presenterId: event.presenterId,
            deliveryAddress: event.deliveryAddress,
            fromLiveStream: event.fromLiveStream,
            checkOutStatus: 'ERROR',
            card: event.card);
    }

  }

  Future<String> callCheckOutApi(DoCartCheckoutProgressUpdate event) async {
    String status;
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client =
        CartApiClient(dio, baseUrl: GlobalConfiguration().getString("baseURL"));
    await client
        .cartCheckout(event.deliveryAddress.id, event.card, event.card.id,
            int.parse(event.card.cvv))
        .then((response) {
      Logger().d("CART-CEHCKOUT-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          break;
        case 400:
          status = "Enter Valid Number";
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("CART-CHECKOUT-ERROR:", error);
      }
    });
    print("PAYMENT INITIATED");

    if (status == "success") {
      ///do real time update for the checkout action

      if (event.fromLiveStream) {
        for (final product in event.products)
          RealTimeController()
              .emitCheckoutFromLive(product.id, event.presenterId);
      }
    }
    return status;
  }
}
