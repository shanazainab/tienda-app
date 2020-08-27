import 'dart:convert';

GetChatMessageResponse getChatMessageResponseFromJson(String str) =>
    GetChatMessageResponse.fromJson(json.decode(str));

String getChatMessageResponseToJson(GetChatMessageResponse data) =>
    json.encode(data.toJson());

class GetChatMessageResponse {
  GetChatMessageResponse({
    this.status,
    this.messages,
  });

  int status;
  List<DirectMessage> messages;

  factory GetChatMessageResponse.fromJson(Map<String, dynamic> json) =>
      GetChatMessageResponse(
        status: json["status"],
        messages: List<DirectMessage>.from(
            json["messages"].map((x) => DirectMessage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
  };
}

class DirectMessage {
  DirectMessage({
    this.id,
    this.userId,
    this.body,
    this.chatType,
    this.receiverId,
    this.createdAt,
    this.received,
  });

  int id;
  int userId;
  String body;
  String chatType;
  int receiverId;
  DateTime createdAt;
  bool received;

  factory DirectMessage.fromJson(Map<String, dynamic> json) => DirectMessage(
    id: json["id"],
    userId: json["user_id"],
    body: json["body"],
    chatType: json["chat_type"],
    receiverId: json["receiver_id"],
    createdAt: DateTime.parse(json["created_at"]),
    received: json["received"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "body": body,
    "chat_type": chatType,
    "receiver_id": receiverId,
    "created_at": createdAt.toIso8601String(),
    "received": received,
  };
}