import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
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
  }

  Stream<PreferenceStates> _mapFetchCountryListToStates(
      FetchCountryList event) async* {
    String status;
    List<Country> countries = new List();
    print("FETCH TEST");
    final dio = Dio();
    final client = PreferenceApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.getCountriesList().then((response) {
      print("#########");
      print("LOGIN-SEND-OTP-RESPONSE:$response");
      for (final item in json.decode(response)['countries']) {
        countries.add(Country.fromJson(item));
      }

      print("#########COUNTRY LIST: $countries ");
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        print('%%%%%%%%%');
        print("COUNTRY LIST-ERROR:${error.response}");

        print("COUNTRY LIST-ERROR:${error.response?.data}");
        print('%%%%%REQUEST%%%%');

        print("COUNTRY LIST-ERROR:${error.request?.data}");
      }
    });
    yield LoadCountryListSuccess(countries: countries);
  }

  Stream<PreferenceStates> _mapFetchCategoryListToStates(FetchCategoryList event) async* {
    List<Category> categories = new List();
    print("FETCH TEST");
    final dio = Dio();
    final client = PreferenceApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.getCategoriesList().then((response) {
      print("#########");
      print("CATEGORY-RESPONSE:$response");
      for (final item in json.decode(response)['categories']) {
        categories.add(Category.fromJson(item));
      }

      print("#########CATEGORY LIST: $categories ");
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        print('%%%%%%%%%');
        print("CATEGORY LIST-ERROR:${error.response}");

        print("CATEGORY LIST-ERROR:${error.response?.data}");
        print('%%%%%REQUEST%%%%');

        print("CATEGORY LIST-ERROR:${error.request?.data}");
      }
    });
    yield LoadCategoryListSuccess(categories: categories);
  }
}
