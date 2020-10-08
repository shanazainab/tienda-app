import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'preference-api-client.g.dart';

@RestApi()
abstract class PreferenceApiClient {
  factory PreferenceApiClient(Dio dio, {String baseUrl}) =
      _PreferenceApiClient;

  @GET("/get_countries/")
  Future<String> getCountriesList();

    @GET("/get_categories/")
  Future<String> getCategoriesList();

  @GET("/get_preferred_categories/")
  Future<String> getPreferredCategories();
}
