import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tienda/api/chat-api-client.dart';
import 'package:tienda/model/chat-history-response.dart';
import 'package:tienda/model/get-chat-message-response.dart';
import 'package:tienda/model/live-chat.dart';
import 'package:tienda/model/live-reaction.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/model/unread-messages.dart';

class RealTimeController {
  final liveChatStream = new BehaviorSubject<List<LiveChat>>();
  final viewCountStream = new BehaviorSubject<String>();

  final directMessageStream = new BehaviorSubject<List<DirectMessage>>();
  final allMessageStream = new BehaviorSubject<List<Message>>();
  final unReadMessage = new BehaviorSubject<List<UnreadMessage>>();
  final liveReaction = new BehaviorSubject<LiveReaction>();

  final liveAddCartStream = new BehaviorSubject<Map<String, dynamic>>();
  final liveCheckOutStream = new BehaviorSubject<Map<String, dynamic>>();
  final mentionedProductStream = new BehaviorSubject<Product>();

  IO.Socket socket;

  RealTimeController._privateConstructor();

  static final RealTimeController _instance =
      RealTimeController._privateConstructor();

  disposeLiveSubjectStreams() {
    liveAddCartStream.drain();
    liveCheckOutStream.drain();
    liveReaction.drain();
    viewCountStream.drain();
    liveChatStream.drain();
    mentionedProductStream.drain();
  }

  disposeDirectMessageStreams() {
    allMessageStream.drain();
    unReadMessage.drain();
  }

  factory RealTimeController() {
    return _instance;
  }

  loadUnreadMessages(List<UnreadMessage> cachedMessages) {
    unReadMessage.sink.add(cachedMessages);
  }

  stopLiveReaction() {
    liveReaction.sink.add(LiveReaction(
      showReaction: false,
      reactionCount: liveReaction.value.reactionCount,
      roomName: liveReaction.value.roomName,
      reaction: liveReaction.value.reaction,
    ));
  }

  addToAllMessageStream(Message message) {
    List<Message> existingAllMessageInStream = allMessageStream.value;
    if (existingAllMessageInStream != null) {
      for (int i = 0; i < existingAllMessageInStream.length; ++i) {
        if (existingAllMessageInStream[i].id == message.id) {
          existingAllMessageInStream[i].lastMessage = message.lastMessage;
        }
      }
      allMessageStream.sink.add(existingAllMessageInStream.reversed.toList());
    }

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
    directMessageStream.drain();
  }

  initialize() async {
    Logger().d("TRYING TO CONNECT");

    String value = await FlutterSecureStorage().read(key: "session-id");

    Logger().e(value);
    log(value);

    if (value != null) {
      socket = IO.io('https://socket.tienda.ae/', <String, dynamic>{
        'transports': ['websocket'],
        'extraHeaders': {'session': value} // optional
      });

      socket.on('connect', (_) {
        Logger().d("REAL TIME CHAT CONTROLLER CONNECTED ");
      });

      socket.on('new_user', (data) {
        ///NEW_USER_EVENT:{viewers: 1, room_name: PR-10}
        Logger().d("NEW_USER_EVENT:$data ");
        viewCountStream.sink.add(data['viewers'].toString());
      });

      socket.on('new_reaction', (data) {
        Logger().d("LIVE_REACTION:$data ");

        ///TODO:PRODUCTION:: LIMIT THE REACTION AMOUNT IF THE STREAM IS OVERLOADED, TOO MANY USERS CASE NEED TO TAKE CARE
        ///TODO:liveReaction.interval(Duration(second: 3))
        liveReaction.sink.add(new LiveReaction(
            showReaction: true,
            reaction: data['reaction'],
            roomName: data['room_name'],
            reactionCount: data['reaction_count']));
      });

      socket.on('RECEIVED_PRODUCT', (data) {
        Logger().d("RECEIVED_PRODUCT:$data ");
        Product product = Product.fromJson(data['product']);
        Logger().d(product);
        mentionedProductStream.sink.add(Product.fromJson(data['product']));
      });

      socket.on('new_in_cart', (data) {
        Logger().d("ADDED PRODUCT TO THE CART:${data['in_cart']} ");
        liveAddCartStream.sink.add(data['in_cart']);
      });
      socket.on('new_checkout', (data) {
        Logger().d("PRODUCT CHECK OUT:$data ");
        liveCheckOutStream.sink.add(data['checkouts']);
      });

      socket.on('PREV_MESSAGES', (data) {
        log("PREV_MESSAGES:$data ");

        List<LiveChat> chats = new List();

        for (final prevMessage in data['prev_messages']) {
          chats.add(new LiveChat(
              prevMessage['message'],
              prevMessage['user_name'],
              prevMessage['profile_picture'],
              DateTime.parse(prevMessage['created_at']).millisecondsSinceEpoch,
              prevMessage['is_premium'] == 0 ? false : true));
        }
        liveChatStream.sink.add(chats.reversed.toList());
      });
      socket.on('new_live_message', (data) {
        Logger().d("NEW_LIVE_MESSAGE_EVENT:$data ");

        if (liveChatStream.value == null) {
          liveChatStream.sink.add([
            new LiveChat(data['body'], data['sender_name'],
                data['sender_profile'], data['sent_at'], data['is_premium'])
          ]);
        } else {
          List<LiveChat> chats = new List();
          chats.add(new LiveChat(data['body'], data['sender_name'],
              data['sender_profile'], data['sent_at'], data['is_premium']));
          chats.addAll(liveChatStream.value);

          liveChatStream.sink.add(chats);
        }
      });
      socket.on('new_message', (data) {
        Logger().d("NEW_MESSAGE:$data ");

        if (directMessageStream.value == null) {
          ///NEW_MESSAGE:{receiver_id: 50, body: dsadsd, timestamp: 1597646863657}
          ///{receiver_id: 50, body: terr, timestamp: 1597835356414, sender_id: 10}
          directMessageStream.sink.add([
            new DirectMessage(
                body: data['body'],
                receiverId: data['receiver_id'],
                createdAt: new DateTime.fromMicrosecondsSinceEpoch(
                    data['timestamp'] * 1000))
          ]);
        } else {
          List<DirectMessage> chatMessages = new List();
          chatMessages.add(new DirectMessage(
              body: data['body'],
              receiverId: data['receiver_id'],
              createdAt: new DateTime.fromMicrosecondsSinceEpoch(
                  data['timestamp'] * 1000)));
          chatMessages.addAll(directMessageStream.value);

          directMessageStream.sink.add(chatMessages);
        }
        addToAllMessageStream(Message(
          elapsedTime: "a sec ago",
          lastMessage: data['body'],
          id: data['sender_id'],
        ));
      });
    }
  }

  emitLiveReaction(int presenterId) {
    Logger().d("EMITTED $presenterId");
    socket.emit('react', {
      'reaction': 'love',
      'room_name': "PR-$presenterId",
      'presenter_id': presenterId
    });
  }

  emitAddToCartFromLive(int productId, int presenterId) {
    socket.emit('added_product_to_cart',
        {'product_id': productId, 'presenter_id': presenterId});
  }

  emitCheckoutFromLive(int productId, int presenterId) {
    socket.emit('product_checkout',
        {'product_id': productId, 'presenter_id': presenterId});
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

  clearLiveChat() {
    liveChatStream.sink.add(null);
  }

  Map<String, List<DirectMessage>> groupedTheMessages(
      List<DirectMessage> chatMessages) {
    Map<String, List<DirectMessage>> groupedMessages = new HashMap();
    for (final message in chatMessages) {
      if (groupedMessages
          .containsKey(message.createdAt.toIso8601String().substring(0, 10))) {
        groupedMessages[message.createdAt.toIso8601String().substring(0, 10)]
            .add(message);
      } else {
        groupedMessages[message.createdAt.toIso8601String().substring(0, 10)] =
            new List()..add(message);
      }
    }

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
