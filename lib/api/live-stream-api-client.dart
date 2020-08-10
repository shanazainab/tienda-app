import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';

part 'live-stream-api-client.g.dart';

@RestApi()
abstract class LiveStreamApiClient {
  factory LiveStreamApiClient(Dio dio, {String baseUrl}) = _LiveStreamApiClient;

  @POST("/join_presenter_live/")
  Future<String> joinTheLive(@Body() int presenterId);


}
