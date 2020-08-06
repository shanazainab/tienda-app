import 'package:logger/logger.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/search-body.dart';

part 'search-api-client.g.dart';

@RestApi()
abstract class SearchApiClient {
  factory SearchApiClient(Dio dio, {String baseUrl}) = _SearchApiClient;

  @POST("/search_products/{query}/")
  Future<String> searchProducts(@Path("query") String query,@Query('page') String pageNumber,@Body() SearchBody searchBody);

  @GET("/search_products_auto_complete/{query}")
  Future<String> getSearchAutoComplete(@Path("query") String query);

  @GET("/get_search_history/")
  Future<String> getSearchHistory();
}
