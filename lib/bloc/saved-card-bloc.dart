import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/payment-api-client.dart';

import 'package:tienda/bloc/events/saved-card-events.dart';
import 'package:tienda/bloc/states/saved-cards-state.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/payment-card.dart';

class SavedCardBloc extends Bloc<SavedCardEvents, SavedCardStates> {
  SavedCardBloc() : super(Loading());

  @override
  Stream<SavedCardStates> mapEventToState(SavedCardEvents event) async* {
    if (event is LoadSavedCards) {
      yield* _mapLoadSavedCardsToStates(event);
    }
    if (event is DeleteSavedCard) {
      yield* _mapDeleteCardsToStates(event);
    }
  }

  Stream<SavedCardStates> _mapDeleteCardsToStates(
      DeleteSavedCard event) async* {
    String status;
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = PaymentApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.deleteSavedCard(event.cardId).then((response) {
      Logger().d("DELETE CARDS:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";

          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("SAVED-CARD-ERROR:", error);
      }
    });

    event.paymentCards.removeWhere((element) => element.id == event.cardId);

    if (status == "success" && event.paymentCards.length != 0)
      yield LoadSavedCardSuccess(paymentCards: event.paymentCards);
    else
      yield SavedCardEmpty();
  }

  Stream<SavedCardStates> _mapLoadSavedCardsToStates(
      LoadSavedCards event) async* {
    String status;
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
          // paymentCards = paymentCardFromJson(json.decode(response)['cards']);
          paymentCards = List<PaymentCard>.from(json
              .decode(response)["cards"]
              .map((x) => PaymentCard.fromJson(x)));
          if (paymentCards.isNotEmpty) status = "success";

          print("PAYMENT CARDS:$paymentCards");

          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("SAVED-CARD-ERROR:", error);
      }
    });

    if (status == "success")
      yield LoadSavedCardSuccess(paymentCards: paymentCards);
    else
      yield SavedCardEmpty();
  }
}
