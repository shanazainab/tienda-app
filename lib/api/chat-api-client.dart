import 'package:logger/logger.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
part 'chat-api-client.g.dart';

@RestApi()
abstract class ChatApiClient {
  factory ChatApiClient(Dio dio, {String baseUrl}) =
  _ChatApiClient;

  @POST("api/v1/message")
  Future<String> createMessage(@Body() String senderId,@Body() String receiverId,@Body() String message,@Body() String socketId);

  @GET("api/v1/message")
  Future<String> getAllMessages();

  @GET("api/v1/message/{senderId}/{receiverId}")
  Future<String> getConversation(@Path("senderId") String senderId, @Path("receiverId") String id);

}
