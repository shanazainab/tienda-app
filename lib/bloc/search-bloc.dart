import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/search-api-client.dart';
import 'package:tienda/bloc/states/search-states.dart';
import 'package:tienda/model/search-history-response.dart';
import 'package:tienda/model/suggestion-response.dart';

import 'events/search-events.dart';

class SearchHistoryBloc extends Bloc<SearchEvents, SearchStates> {
  SearchHistoryBloc() : super(Loading());



  @override
  Stream<SearchStates> mapEventToState(SearchEvents event) async* {
    if (event is LoadSearchHistory) {
      yield* _mapLoadSearchHistoryToStates(event);
    }
  }

  Stream<SearchStates> _mapLoadSearchHistoryToStates(
      LoadSearchHistory event) async* {
    final dio = Dio();
    SearchHistoryResponse searchHistoryResponse;
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = SearchApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.getSearchHistory().then((response) {
      Logger().d("SEARCH-HISTORY-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          searchHistoryResponse = searchHistoryResponseFromJson(response);
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("SEARCH-hISTORY-ERROR:", error);
      }
    });
    if(searchHistoryResponse != null)
    yield LoadSearchHistoryComplete(searchHistoryResponse);
  }
}

class SearchBloc extends Bloc<SearchEvents, SearchStates> {
  SearchBloc() : super(Loading());



  @override
  Stream<SearchStates> mapEventToState(SearchEvents event) async* {
    if (event is ProductSearchAutocomplete) {
      yield* _mapProductSearchAutocompleteToStates(event);
    }
    if (event is StopSuggestions) {
      yield NoSuggestions();
    }
  }

  Stream<SearchStates> _mapProductSearchAutocompleteToStates(
      ProductSearchAutocomplete event) async* {
    List<Suggestion> suggestions;

    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = SearchApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.getSearchAutoComplete(event.query).then((response) {
      Logger().d("SEARCH-AUTOCOMPLETE-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          SuggestionResponse suggestionResponse =
              suggestionResponseFromJson(response);
          suggestions = suggestionResponse.suggestions;
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("SEARCH-AUTOCOMPLETE-ERROR:", error);
      }
    });
    if (suggestions != null && suggestions.isNotEmpty)
      yield ProductSearchAutoCompleteSuccess(suggestions);
  }
}
