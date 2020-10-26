import 'dart:convert';

LiveReaction liveReactionFromJson(String str) => LiveReaction.fromJson(json.decode(str));

String liveReactionToJson(LiveReaction data) => json.encode(data.toJson());

class LiveReaction {
  LiveReaction({
    this.reaction,
    this.roomName,
    this.reactionCount,
    this.showReaction
  });

  String reaction;
  String roomName;
  int reactionCount;
  bool showReaction;

  factory LiveReaction.fromJson(Map<String, dynamic> json) => LiveReaction(
    reaction: json["reaction"],
    roomName: json["room_name"],
    reactionCount: json["reaction_count"],
  );

  Map<String, dynamic> toJson() => {
    "reaction": reaction,
    "room_name": roomName,
    "reaction_count": reactionCount,
  };
}
