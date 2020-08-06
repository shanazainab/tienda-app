import 'dart:convert';
import 'dart:developer';
import 'package:dash_chat/dash_chat.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/chat-api-client.dart';
import 'package:tienda/bloc/events/chat-events.dart';
import 'package:tienda/bloc/states/chat-states.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/conversation-response.dart';

class ChatBloc extends Bloc<ChatEvents, ChatStates> {
  IO.Socket socket;

  @override
  ChatStates get initialState => Loading();

  @override
  Stream<ChatStates> mapEventToState(ChatEvents event) async* {
    if (event is Initialize) {
      yield* _mapInitializeToStates(event);
    }
    if (event is GetConversation) {
      yield* _mapGetConversationToStates(event);
    }
    if (event is SendMessage) {
      yield* _mapFetchSendMessageToStates(event);
    }
  }

  Stream<ChatStates> _mapInitializeToStates(Initialize event) async* {
    socket =
        IO.io(GlobalConfiguration().getString("chatURL"), <String, dynamic>{
      'transports': ['websocket'],
    });
     socket.on('connect', (_) {
      print('connect');
      socket.emit('msg', 'test');
    });

    socket.on('recieved', (_) {
     Logger().d("SOCKET RECEIVER: $_");
    });

    yield InitializeComplete();
  }

  Stream<ChatStates> _mapGetConversationToStates(GetConversation event) async* {

    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;

    String status;
    List<ChatMessage> chatMessages = new List();

    ChatApiClient chatApiClient =
        ChatApiClient(dio, baseUrl: GlobalConfiguration().getString("chatURL"));
    await chatApiClient
        .getConversation(event.senderId, event.receiverId)
        .then((response) {
      Logger().d("GET-CONVERSATION-MESSAGE-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case "Success":
          ConversationResponse conversationResponse =
              conversationResponseFromJson(response);
          for (final message in conversationResponse.data.messages) {
            chatMessages.add(new ChatMessage(
              text: message.message,
              createdAt: message.dateCreated.add(Duration(hours: 4)),
              user: new ChatUser(
                name: message.senderId,
                uid: event.senderId,
              ),
            ));
          }
          status = "success";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        log("GET-CONVERSATION-MESSAGE-ERROR:, ${error.response.data}");
        log("GET-CONVERSATION-MESSAGE-ERROR:, ${error.request.data}");
      }
    });

    if (status == "success") {
      yield FetchMessagesComplete(chatMessages: chatMessages);
    }
  }

  Stream<ChatStates> _mapFetchSendMessageToStates(SendMessage event) async* {
    if (event.chatMessages == null) event.chatMessages = new List();
    event.chatMessages.add(event.newMessage);
    yield MessageSend(chatMessages: event.chatMessages);
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;

    String status;

    ChatApiClient chatApiClient =
        ChatApiClient(dio, baseUrl: GlobalConfiguration().getString("chatURL"));
    await chatApiClient
        .createMessage(event.newMessage.user.uid, event.receiverId,
            event.newMessage.text, socket.id)
        .then((response) {
      Logger().d("CREATE-MESSAGE-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        log("CREATE-MESSAGE-ERROR:, ${error.response.data}");

        log("CREATE-MESSAGE-ERROR:, ${error.request.data}");
      }
    });

    if (status == "success") {}
  }
}
