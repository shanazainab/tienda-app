import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'home-api-client.g.dart';

@RestApi()
abstract class HomeApiClient {
  factory HomeApiClient(Dio dio, {String baseUrl}) = _HomeApiClient;

  @GET("/main_screen_data/")
  Future<String> getHomeScreenData();

  @GET("/get_live_streams/")
  Future<String> getLiveContents();
}
