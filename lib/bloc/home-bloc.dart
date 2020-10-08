import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/home-api-client.dart';
import 'package:tienda/bloc/states/home-states.dart';
import 'package:tienda/model/home-screen-data-response.dart';

import 'events/home-events.dart';

class HomeBloc extends Bloc<HomeEvents, HomeStates> {
  HomeBloc() : super(Loading());


  @override
  Stream<HomeStates> mapEventToState(HomeEvents event) async* {
    if (event is FetchHomeData) {
      yield* _mapFetchHomeDataToStates(event);
    }


  }

  Stream<HomeStates> _mapFetchHomeDataToStates(FetchHomeData event) async* {
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    HomeScreenResponse homeScreenResponse;
    HomeApiClient homeApiClient =
        HomeApiClient(dio, baseUrl: GlobalConfiguration().getString("baseURL"));
    await homeApiClient.getHomeScreenData().then((response) {
      log("HOME DATA RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          homeScreenResponse = homeScreenResponseFromJson(response);
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("HOME-SCREEN-ERROR:", error);
      }
    });
    if (homeScreenResponse != null) yield LoadDataSuccess(homeScreenResponse);
  }
}
