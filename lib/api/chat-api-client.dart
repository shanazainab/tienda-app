import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'chat-api-client.g.dart';

@RestApi()
abstract class ChatApiClient {
  factory ChatApiClient(Dio dio, {String baseUrl}) = _ChatApiClient;

  @GET("/get_chats/")
  Future<String> getChats();

  @POST("/get_chat_messages/")
  Future<String> getChatMessages(@Body() int presenterId);
}
