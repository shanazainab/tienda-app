import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';

part 'home-api-client.g.dart';

@RestApi()
abstract class HomeApiClient {
  factory HomeApiClient(Dio dio, {String baseUrl}) = _HomeApiClient;

  @GET("/main_screen_data/")
  Future<String> getHomeScreenData();


}
