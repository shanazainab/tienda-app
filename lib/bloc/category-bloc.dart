import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/preference-api-client.dart';
import 'package:tienda/bloc/events/category-events.dart';
import 'package:tienda/bloc/states/category-states.dart';
import 'package:tienda/model/category.dart';

class CategoryBlock extends Bloc<CategoryEvents, CategoryStates> {
  CategoryBlock() : super(Loading());



  @override
  Stream<CategoryStates> mapEventToState(CategoryEvents event) async* {
    if (event is LoadCategories) {
      yield* _mapFetchHomeDataToStates(event);
    }
  }

  Stream<CategoryStates> _mapFetchHomeDataToStates(
      LoadCategories event) async* {
    List<Category> categories = new List();
    final dio = Dio();
    final client = PreferenceApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.getCategoriesList().then((response) {
      Logger().d("CATEGORY-RESPONSE:$response");
      for (final item in json.decode(response)['categories']) {
        categories.add(Category.fromJson(item));
      }

    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("CATEGORY LIST-ERROR:", error);
      }
    });

    if(categories.isNotEmpty)
    yield LoadCategoriesSuccess(
        categories: categories, selectedCategory: categories[0]);
  }
}
