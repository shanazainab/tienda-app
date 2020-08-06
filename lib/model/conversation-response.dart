// To parse this JSON data, do
//
//     final conversationResponse = conversationResponseFromJson(jsonString);

import 'dart:convert';

ConversationResponse conversationResponseFromJson(String str) => ConversationResponse.fromJson(json.decode(str));

String conversationResponseToJson(ConversationResponse data) => json.encode(data.toJson());

class ConversationResponse {
  ConversationResponse({
    this.status,
    this.results,
    this.data,
  });

  String status;
  int results;
  Data data;

  factory ConversationResponse.fromJson(Map<String, dynamic> json) => ConversationResponse(
    status: json["status"],
    results: json["results"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "results": results,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.messages,
  });

  List<Message> messages;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
  };
}

class Message {
  Message({
    this.dateCreated,
    this.id,
    this.senderId,
    this.recieverId,
    this.message,
    this.socketId,
    this.v,
  });

  DateTime dateCreated;
  String id;
  String senderId;
  String recieverId;
  String message;
  String socketId;
  int v;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    dateCreated: DateTime.parse(json["date_created"]).toLocal(),
    id: json["_id"],
    senderId: json["sender_id"],
    recieverId: json["reciever_id"],
    message: json["message"],
    socketId: json["socket_id"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "date_created": dateCreated.toIso8601String(),
    "_id": id,
    "sender_id": senderId,
    "reciever_id": recieverId,
    "message": message,
    "socket_id": socketId,
    "__v": v,
  };
}
