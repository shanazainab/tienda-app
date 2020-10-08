// To parse this JSON data, do
//
//     final watchHistory = watchHistoryFromJson(jsonString);

import 'dart:convert';

WatchHistory watchHistoryFromJson(String str) => WatchHistory.fromJson(json.decode(str));

String watchHistoryToJson(WatchHistory data) => json.encode(data.toJson());

class WatchHistory {
  WatchHistory({
    this.title,
    this.url,
    this.thumbnail,
  });

  String title;
  String url;
  String thumbnail;

  factory WatchHistory.fromJson(Map<String, dynamic> json) => WatchHistory(
    title: json["title"],
    url: json["url"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "url": url,
    "thumbnail": thumbnail,
  };
}
