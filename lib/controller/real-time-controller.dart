import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tienda/api/chat-api-client.dart';
import 'package:tienda/model/chat-history-response.dart';
import 'package:tienda/model/get-chat-message-response.dart';
import 'package:tienda/model/live-chat.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/unread-messages.dart';

class RealTimeController {
  final liveChatStream = new BehaviorSubject<List<LiveChat>>();
  final viewCountStream = new BehaviorSubject<String>();

  final directMessageStream = new BehaviorSubject<List<DirectMessage>>();
  final allMessageStream = new BehaviorSubject<List<Message>>();
  final unReadMessage = new BehaviorSubject<List<UnreadMessage>>();
  final liveReaction = new BehaviorSubject<bool>();

  IO.Socket socket;

  RealTimeController._privateConstructor();

  static final RealTimeController _instance =
      RealTimeController._privateConstructor();

  factory RealTimeController() {
    return _instance;
  }

  loadUnreadMessages(List<UnreadMessage> cachedMessages) {
    unReadMessage.sink.add(cachedMessages);
  }

  showLiveReaction(int presenterId) {
    socket.emit('react', {'reaction': 'love', 'room_name': "PR-$presenterId"});
  }

  stopLiveReaction() {
    liveReaction.sink.add(false);
  }

  clearLiveChat() {
    liveChatStream.sink.add(null);
  }

  addToAllMessageStream(Message message) {
    List<Message> existingAllMessageInStream = allMessageStream.value;

    for (int i = 0; i < existingAllMessageInStream.length; ++i) {
      if (existingAllMessageInStream[i].id == message.id) {
        existingAllMessageInStream[i].lastMessage = message.lastMessage;
      }
    }
    allMessageStream.sink.add(existingAllMessageInStream.reversed.toList());

    Logger().d("ALL STREAM CALLED");
  }

  updateUnreadMessages(int presenterId) {
    List<UnreadMessage> unReadMessages = unReadMessage.value;
    Logger().d(unReadMessages.toString());

    if (unReadMessages != null) {
      unReadMessages
          .removeWhere((element) => element.presenterId == presenterId);

      unReadMessage.sink.add(unReadMessages);
    }
    Logger().d(unReadMessages);
  }

  receiveUnreadMessages(UnreadMessage message) {
    Logger().d(message);

    if ((unReadMessage.value == null) ||
        (unReadMessage.value != null && unReadMessage.value.isEmpty)) {
      unReadMessage.sink.add([message]);
    } else {
      List<UnreadMessage> unReadMessages = unReadMessage.value;
      Logger().d(unReadMessages);

      for (final old in unReadMessages) {
        if (old.presenterId == message.presenterId) {
          old.messages.add(message.messages[0]);
        } else {
          unReadMessages.add(message);
        }
      }
      unReadMessage.sink.add(unReadMessages);
      Logger().d(unReadMessages);
    }
  }

  clearDirectMessageStream() {
    directMessageStream.add(null);
  }

  initialize() async {
    Logger().d("TRYING TO CONNECT");

    String value = await FlutterSecureStorage().read(key: "session-id");

    if (value != null) {
      socket = IO.io('http://167.179.93.235:3000/', <String, dynamic>{
        'transports': ['websocket'],
        'extraHeaders': {'session': value} // optional
      });

      socket.on('connect', (_) {
        Logger().d("REAL TIME CHAT CONTROLLER CONNECTED ");
      });

      socket.on('new_user', (data) {
        ///NEW_USER_EVENT:{viewers: 1, room_name: PR-10}
        viewCountStream.sink.add(data['viewers'].toString());

        Logger().d("NEW_USER_EVENT:$data ");
      });

      socket.on('new_reaction', (data) {
        Logger().d("LIVE_REACTION:$data ");
        liveReaction.sink.add(true);
      });

      socket.on('new_live_message', (data) {
        Logger().d("NEW_LIVE_MESSAGE_EVENT:$data ");

        if (liveChatStream.value == null) {
          liveChatStream.add([
            new LiveChat(data['body'], data['sender_name'],
                data['sender_profile'], data['sent_at'], data['is_premium'])
          ]);
        } else {
          List<LiveChat> chats = new List();
          chats.add(new LiveChat(data['body'], data['sender_name'],
              data['sender_profile'], data['sent_at'], data['is_premium']));
          chats.addAll(liveChatStream.value);

          liveChatStream.add(chats);
        }
      });
      socket.on('new_message', (data) {
        Logger().d("NEW_MESSAGE:$data ");

        if (directMessageStream.value == null) {
          ///NEW_MESSAGE:{receiver_id: 50, body: dsadsd, timestamp: 1597646863657}
          ///{receiver_id: 50, body: terr, timestamp: 1597835356414, sender_id: 10}
          directMessageStream.add([
            new DirectMessage(
                body: data['body'],
                receiverId: data['receiver_id'],
                createdAt:
                    new DateTime.fromMicrosecondsSinceEpoch(data['timestamp']))
          ]);
        } else {
          List<DirectMessage> chatMessages = new List();
          chatMessages.add(new DirectMessage(
              body: data['body'],
              receiverId: data['receiver_id'],
              createdAt:
                  new DateTime.fromMicrosecondsSinceEpoch(data['timestamp'])));
          chatMessages.addAll(directMessageStream.value);

          directMessageStream.add(chatMessages);
        }
        addToAllMessageStream(Message(
          elapsedTime: "a sec ago",
          lastMessage: data['body'],
          id: data['sender_id'],
        ));
        Logger().d("NEW_MESSAGE:$data ");
      });
    }
  }

  emitLiveMessage(String message, int presenterId) {
    socket.emit('live_message', {'body': message, 'presenter_id': presenterId});
  }

  emitJoinLive(int presentId) {
    socket.emit('join_live', {'presenter_id': presentId});
  }

  sendDirectMessage(DirectMessage chatMessage) {
    socket.emit('new_message', {
      'body': chatMessage.body,
      'receiver_id': 10,
      'type': 'customer_presenter'
    });

    if (directMessageStream.value == null) {
      ///NEW_MESSAGE:{receiver_id: 50, body: dsadsd, timestamp: 1597646863657}
      directMessageStream.sink.add([chatMessage]);
    } else {
      List<DirectMessage> chatMessages = new List();
      chatMessages.add(chatMessage);
      chatMessages.addAll(directMessageStream.value);
      directMessageStream.sink.add(chatMessages);
    }
  }

  Future<void> getPresenterChats(int presenterId) async {
    final dio = Dio();
    String status;

    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    ChatApiClient chatApiClient =
        ChatApiClient(dio, baseUrl: GlobalConfiguration().getString("baseURL"));
    await chatApiClient.getChatMessages(presenterId).then((response) {
      log("GET-CHAT-MESSAGES-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "SUCCESS";
          GetChatMessageResponse getChatMessageResponse =
              getChatMessageResponseFromJson(response);
          List<DirectMessage> chatMessages = new List();
          for (final message in getChatMessageResponse.messages) {
            chatMessages.add(message);
          }
          directMessageStream.sink.add(chatMessages.reversed.toList());
          break;
        case 404:
          status = "NOT_AUTHORIZED";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET-CHAT-MESSAGES-ERROR:", error);
      }
    });
  }

  Map<String, List<DirectMessage>> groupMessagesByDate(List<DirectMessage> chatMessages) {
    Map<String, List<DirectMessage>> groupedMessages = new HashMap();
    for (final chatMessage in chatMessages) {
      if (groupedMessages.containsKey(
          chatMessage.createdAt.toIso8601String().substring(0, 10))) {
        groupedMessages[
                chatMessage.createdAt.toIso8601String().substring(0, 10)]
            .add(chatMessage);
      } else {
        groupedMessages[chatMessage.createdAt
            .toIso8601String()
            .substring(0, 10)] = [chatMessage];
      }
    }

    log(groupedMessages.toString());

    return groupedMessages;

  }

  Future<void> getAllPresenterChats() async {
    final dio = Dio();
    String status;

    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    ChatApiClient chatApiClient =
        ChatApiClient(dio, baseUrl: GlobalConfiguration().getString("baseURL"));
    await chatApiClient.getChats().then((response) {
      log("GET-CHATS-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "SUCCESS";

          ///{"status": 200, "chats": [{"id": 10, "name": "Bella", "profile_picture": "/media/sampleone.jpg"}]}

          ChatHistoryResponse allChatResponse =
              allChatResponseFromJson(response);

          allMessageStream.sink.add(allChatResponse.chats);

          break;
        case 404:
          status = "NOT_AUTHORIZED";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET-CHATS-ERROR:", error);
      }
    });
  }
}
