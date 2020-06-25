import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/api/preference-api-client.dart';
import 'package:tienda/bloc/states/preference-states.dart';
import 'package:dio/dio.dart';
import 'package:tienda/console-logger.dart';
import 'package:tienda/model/category.dart';
import 'package:tienda/model/country.dart';

import 'events/preference-events.dart';

class PreferenceBloc extends Bloc<PreferenceEvents, PreferenceStates> {
  ConsoleLogger consoleLogger = new ConsoleLogger();

  @override
  PreferenceStates get initialState => Loading();

  @override
  Stream<PreferenceStates> mapEventToState(PreferenceEvents event) async* {
    if (event is FetchCountryList) {
      yield* _mapFetchCountryListToStates(event);
    }
    if (event is FetchCategoryList) {
      yield* _mapFetchCategoryListToStates(event);
    }
  }

  Stream<PreferenceStates> _mapFetchCountryListToStates(
      FetchCountryList event) async* {
    String status;
    List<Country> countries = new List();
    final dio = Dio();
    final client = PreferenceApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.getCountriesList().then((response) {
      consoleLogger.printResponse("LIST-COUNTRY-RESPONSE:$response");
      for (final item in json.decode(response)['countries']) {
        countries.add(Country.fromJson(item));
      }

      consoleLogger.printResponse("#########COUNTRY LIST: $countries ");
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        consoleLogger.printDioError("COUNTRY LIST-ERROR:",error);


      }
    });
    yield LoadCountryListSuccess(countries: countries);
  }

  Stream<PreferenceStates> _mapFetchCategoryListToStates(
      FetchCategoryList event) async* {
    List<Category> categories = new List();
    final dio = Dio();
    final client = PreferenceApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.getCategoriesList().then((response) {
      consoleLogger.printResponse("CATEGORY-RESPONSE:$response");
      for (final item in json.decode(response)['categories']) {
        categories.add(Category.fromJson(item));
      }

      consoleLogger.printResponse("#########CATEGORY LIST: $categories ");
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        consoleLogger.printDioError("CATEGORY LIST-ERROR:",error);

      }
    });
    yield LoadCategoryListSuccess(categories: categories);
  }
}
