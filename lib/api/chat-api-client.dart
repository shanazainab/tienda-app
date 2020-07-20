import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
part 'chat-api-client.g.dart';

@RestApi()
abstract class CartApiClient {
  factory CartApiClient(Dio dio, {String baseUrl}) =
  _CartApiClient;

  @POST("api/v1/message")
  Future<String> createMessage(@Body() String senderId,@Body() String receiverId,@Body() String message);

  @GET("api/v1/message")
  Future<String> getAllAddress();

  @POST("api/v1/message/{receiverId}")
  Future<String> getConversation(@Body() String senderId, @Path('receiverId') String receiverId);

}
