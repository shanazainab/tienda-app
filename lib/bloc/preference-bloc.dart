import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/api/preference-api-client.dart';
import 'package:tienda/bloc/states/preference-states.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/category.dart';
import 'package:tienda/model/country.dart';

import 'events/preference-events.dart';

class PreferenceBloc extends Bloc<PreferenceEvents, PreferenceStates> {
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
    if (event is GetCountryPreference) {
      yield* _mapGetCountryPreferenceToStates(event);
    }
    if (event is FetchPreferredCategoryList) {
      yield* _mapFetchPreferredCategoryListToStates(event);
    }
  }

  Stream<PreferenceStates> _mapGetCountryPreferenceToStates(
      GetCountryPreference event) async* {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey("country")) {
      var country = Country.fromJson(sharedPreferences.get("country"));
      yield FetchCountryPreferenceSuccess(country: country);
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
      Logger().d("LIST-COUNTRY-RESPONSE:$response");
      for (final item in json.decode(response)['countries']) {
        countries.add(Country.fromJson(item));
      }

      Logger().d("#########COUNTRY LIST: $countries ");
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("COUNTRY LIST-ERROR:", error);
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
      Logger().d("CATEGORY-RESPONSE:$response");
      for (final item in json.decode(response)['categories']) {
        categories.add(Category.fromJson(item));
      }

      Logger().d("#########CATEGORY LIST: $categories ");
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("CATEGORY LIST-ERROR:", error);
      }
    });
    yield LoadCategoryListSuccess(categories: categories);
  }

  Stream<PreferenceStates> _mapFetchPreferredCategoryListToStates(
      FetchPreferredCategoryList event) async* {
    List<Category> categories = new List();
    final dio = Dio();
    final client = PreferenceApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.getCategoriesList().then((response) {
      Logger().d("PREFERRED-CATEGORY-RESPONSE:$response");
      for (final item in json.decode(response)['categories']) {
        categories.add(Category.fromJson(item));
      }

      Logger().d("#########PREFERRED-CATEGORY CATEGORY LIST: $categories ");
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("PREFERRED-CATEGORY CATEGORY LIST-ERROR:", error);
      }
    });
    yield LoadPreferredCategoryListSuccess(categories: categories);
  }
}
