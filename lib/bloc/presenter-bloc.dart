import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/presenter-api-client.dart';
import 'package:tienda/bloc/events/presenter-events.dart';
import 'package:tienda/bloc/states/presenter-states.dart';
import 'package:tienda/model/live-presenter-response.dart';
import 'package:tienda/model/presenter-category.dart';
import 'package:tienda/model/presenter.dart';

class PresenterBloc extends Bloc<PresenterEvents, PresenterStates> {
  PresenterBloc() : super(Loading());

  @override
  Stream<PresenterStates> mapEventToState(PresenterEvents event) async* {
    if (event is LoadPresenterList) {
      yield* _mapLoadPresenterListToStates(event);
    }
    if (event is LoadPresenterDetails) {
      yield* _mapLoadPresenterDetailsToStates(event);
    }
    if (event is LoadLivePresenter) {
      yield* _mapLivePresentersToStates(event);
    }
    if (event is LoadPopularPresenters) {
      yield* _mapPopularPresentersToStates(event);
    }
  }

  Stream<PresenterStates> _mapPopularPresentersToStates(
      LoadPopularPresenters event) async* {
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    List<Presenter> presenters;

    PresenterApiClient presenterApiClient = PresenterApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await presenterApiClient.getPopularPresenters().then((response) {
      log("GET-POPULAR-PRESENTERS-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          presenters = List<Presenter>.from(json
              .decode(response)['presenters']
              .map((x) => Presenter.fromJson(x)));
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET-POPULAR-PRESENTERS-ERROR:", error);
      }
    });

    if (presenters != null) yield LoadPopularPresentersSuccess(presenters: presenters);
  }
}

Stream<PresenterStates> _mapLivePresentersToStates(
    LoadLivePresenter event) async* {
  LivePresenterResponse livePresenterResponse;

  final dio = Dio();
  String value = await FlutterSecureStorage().read(key: "session-id");
  dio.options.headers["Cookie"] = value;
  PresenterApiClient presenterApiClient = PresenterApiClient(dio,
      baseUrl: GlobalConfiguration().getString("baseURL"));
  await presenterApiClient.getLivePresenters().then((response) {
    log("GET-LIVE-PRESENTERS-RESPONSE:$response");
    switch (json.decode(response)['status']) {
      case 200:
        livePresenterResponse = livePresenterResponseFromJson(response);
        break;
    }
  }).catchError((err) {
    if (err is DioError) {
      DioError error = err;
      Logger().e("GET-LIVE-PRESENTERS-ERROR:", error);
    }
  });

  if (livePresenterResponse != null) {
    yield LoadLivePresenterSuccess(livePresenterResponse.presenters);
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
    log("GET-PRESENTER-LIST-RESPONSE:$response");
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
  String status;
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
        status = "SUCCESS";
        presenter =
            presenterFromJson(json.encode(json.decode(response)['presenter']));
        break;
      case 404:
        status = "NOT_AUTHORIZED";
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
