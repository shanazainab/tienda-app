import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/presenter-api-client.dart';
import 'package:tienda/bloc/events/presenter-events.dart';
import 'package:dio/dio.dart';
import 'package:tienda/bloc/states/presenter-states.dart';
import 'package:tienda/model/presenter-category.dart';
import 'package:tienda/model/presenter.dart';

class PresenterBloc extends Bloc<PresenterEvents, PresenterStates> {
  @override
  PresenterStates get initialState => Loading();

  @override
  Stream<PresenterStates> mapEventToState(PresenterEvents event) async* {
    if (event is LoadPresenterList) {
      yield* _mapLoadPresenterListToStates(event);
    }
    if (event is LoadPresenterDetails) {
      yield* _mapLoadPresenterDetailsToStates(event);
    }
  }

  Stream<PresenterStates> _mapLoadPresenterListToStates(
      LoadPresenterList event) async* {
    PresenterCategory presenterCategory;

    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    PresenterApiClient presenterApiClient = PresenterApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await presenterApiClient.getPresenterList().then((response) {
      Logger().d("GET-PRESENTER-LIST-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          presenterCategory = presenterCategoryFromJson(response);
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET-PRODUCT-LIST-ERROR:", error);
      }
    });

    if (presenterCategory != null) {
      List<Presenter> presenter = new List();
      for (final item in presenterCategory.response) {
        for (final pre in item.presenters) presenter.add(pre);
      }
      yield LoadPresenterListSuccess(presenterCategory, presenter);
    }
  }

  Stream<PresenterStates> _mapLoadPresenterDetailsToStates(
      LoadPresenterDetails event) async* {
    final dio = Dio();
    Presenter presenter;

    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    PresenterApiClient presenterApiClient = PresenterApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await presenterApiClient
        .getPresenterDetails(event.presenterId.toString())
        .then((response) {
      log("GET-PRESENTER-DETAILS-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          presenter = presenterFromJson(
              json.encode(json.decode(response)['presenter']));
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET-PRESENTER-DETAILS-ERROR:", error);
      }
    });

    if (presenter != null) yield LoadPresenterDetailsSuccess(presenter);
  }
}
