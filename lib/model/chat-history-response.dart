import 'dart:convert';

///{"status": 200, "chats": [{"id": 10, "name": "Bella", "profile_picture": "/media/sampleone.jpg", "last_message": "vhb", "elapsed_time": "3 minutes ago"}]}
ChatHistoryResponse allChatResponseFromJson(String str) =>
    ChatHistoryResponse.fromJson(json.decode(str));

String allChatResponseToJson(ChatHistoryResponse data) =>
    json.encode(data.toJson());

class ChatHistoryResponse {
  ChatHistoryResponse({
    this.status,
    this.chats,
  });

  int status;
  List<Message> chats;

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) =>
      ChatHistoryResponse(
        status: json["status"],
        chats:
            List<Message>.from(json["chats"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "chats": List<dynamic>.from(chats.map((x) => x.toJson())),
      };
}

class Message {
  /// "last_message": "vhb", "elapsed_time": "3 minutes ago"

  Message(
      {this.id,
      this.name,
      this.profilePicture,
      this.lastMessage,
      this.elapsedTime});

  int id;
  String name;
  String profilePicture;
  String lastMessage;
  String elapsedTime;


  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        name: json["name"],
        profilePicture: json["profile_picture"],
        lastMessage: json["last_message"],
        elapsedTime: json["elapsed_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile_picture": profilePicture,
        "last_message": lastMessage,
        "elapsed_time": elapsedTime
      };
}
