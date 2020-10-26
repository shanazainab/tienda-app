import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/address-api-client.dart';
import 'package:tienda/api/payment-api-client.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/states/checkout-states.dart';
import 'package:tienda/model/delivery-address.dart';
import 'package:tienda/model/payment-card.dart';

import 'address-bloc.dart';

class LiveStreamCheckOutBloc extends Bloc<CheckoutEvents, CheckoutStates> {
  LiveStreamCheckOutBloc() : super(Loading());

  @override
  Stream<CheckoutStates> mapEventToState(CheckoutEvents event) async* {
    if (event is InitializeLiveStreamCheckout) {
      print("event is called");
      yield* _mapInitializeCheckoutToStates(event);
    }

    if (event is UpdateLiveCheckout) {
      yield UpdateLiveCheckoutComplete(
          card: event.card, deliveryAddress: event.deliveryAddress);
    }
  }

  Stream<CheckoutStates> _mapInitializeCheckoutToStates(
      InitializeLiveStreamCheckout event) async* {
    ///call address api and return one single address (default or only one in the list or the recent one used)

    List<DeliveryAddress> addresses = await callSavedAddressApi();
    DeliveryAddress chosenAddress;

    if (addresses != null && addresses.isNotEmpty) {
      if (addresses.length == 1)
        chosenAddress = addresses[0];
      else {
        for (final address in addresses) {
          if (address.isDefault) {
            chosenAddress = address;
            break;
          }
        }
      }
    }

    ///call save card api , same principle as saved address
    List<PaymentCard> paymentCards = await callSavedCardApi();
    PaymentCard chosenPaymentCard;

    if (paymentCards != null && paymentCards.isNotEmpty) {
      chosenPaymentCard = paymentCards[0];
    }

    yield LiveCheckoutInitializationComplete(
        card: chosenPaymentCard, deliveryAddress: chosenAddress);
  }

  Future<List<PaymentCard>> callSavedCardApi() async {
    List<PaymentCard> paymentCards;
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = PaymentApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.getSavedCards().then((response) {
      Logger().d("SAVED CARDS:$response");
      switch (json.decode(response)['status']) {
        case 200:
          paymentCards = List<PaymentCard>.from(json
              .decode(response)["cards"]
              .map((x) => PaymentCard.fromJson(x)));

          print("PAYMENT CARDS:$paymentCards");

          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("SAVED-CARD-ERROR:", error);
      }
    });
    return paymentCards;
  }

  Future<List<DeliveryAddress>> callSavedAddressApi() async {
    List<DeliveryAddress> addresses = new List();
    print("calling saved address api");
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = AddressApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.getSavedAddress().then((response) {
      Logger().d("GET-SAVED-ADDRESS-RESPONSE:$response");

      DeliverAddressResponse data = deliverAddressResponseFromJson(response);
      switch (data.status) {
        case 200:
          if (data.addresses.isNotEmpty) {
            addresses = data.addresses;
          }

          break;
        case 401:
          addresses = null;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET-SAVED-ADDRESS-ERROR:$error");
        Logger().e("GET-SAVED-ADDRESS-DATA:${error.response?.data}");
        Logger().e("GET-SAVED-ADDRESS-REQUEST:${error.request?.data}");
      }
    });

    return addresses;
  }
}
