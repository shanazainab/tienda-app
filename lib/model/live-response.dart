// To parse this JSON data, do
//
//     final liveResponse = liveResponseFromJson(jsonString);

import 'dart:convert';

import 'package:tienda/model/product.dart';

LiveResponse liveResponseFromJson(String str) =>
    LiveResponse.fromJson(json.decode(str));

String liveResponseToJson(LiveResponse data) => json.encode(data.toJson());

class LiveResponse {
  ///"is_followed": true,
  LiveResponse(
      {this.status,
      this.isLive,
      this.products,
      this.url,
      this.title,
      this.reactions,
      this.m3u8URL,
      this.isFollowed});

  int status;
  bool isLive;
  List<Product> products;
  String url;
  String m3u8URL;
  bool isFollowed;
  String title;
  int reactions;

  factory LiveResponse.fromJson(Map<String, dynamic> json) => LiveResponse(
      status: json["status"],
      isLive: json["is_live"],
      products:
          List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
      url: json["url"],
      title: json['title'],
      reactions: json['reactions'],
      m3u8URL: json['m3u8_url'],
      isFollowed: json['is_followed']);

  Map<String, dynamic> toJson() => {
        "status": status,
        "is_live": isLive,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "url": url,
        "title": title,
        "reactions": reactions,
        "m3u8_url": m3u8URL,
        "is_followed": isFollowed
      };
}
