import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
part 'preference-api-client.g.dart';

@RestApi()
abstract class PreferenceApiClient {
  factory PreferenceApiClient(Dio dio, {String baseUrl}) =
      _PreferenceApiClient;

  @POST("/get_countries/")
  Future<String> getCountriesList();

    @POST("/get_categories/")
  Future<String> getCategoriesList();
}
