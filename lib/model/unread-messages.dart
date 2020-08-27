import 'dart:convert';

import 'package:equatable/equatable.dart';

List<UnreadMessage> unreadMessageFromJson(String str) =>
    List<UnreadMessage>.from(
        json.decode(str).map((x) => UnreadMessage.fromJson(x)));

String unreadMessageToJson(List<UnreadMessage> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UnreadMessage extends Equatable {
  UnreadMessage({
    this.presenterId,
    this.name,
    this.profileImage,
    this.messages,
    this.elapsedTime,
  });

  @override
  List<Object> get props => [presenterId];
  int presenterId;
  String name;
  String profileImage;
  List<String> messages;
  int elapsedTime;

  factory UnreadMessage.fromJson(Map<String, dynamic> json) => UnreadMessage(
    presenterId: json["presenter_id"],
    name: json["name"],
    profileImage: json["profile_image"],
    messages: List<String>.from(json["messages"].map((x) => x)),
    elapsedTime: json["elapsed_time"],
  );

  Map<String, dynamic> toJson() => {
    "presenter_id": presenterId,
    "name": name,
    "profile_image": profileImage,
    "messages": List<dynamic>.from(messages.map((x) => x)),
    "elapsed_time": elapsedTime,
  };
}