// To parse this JSON data, do
//
//     final presenter = presenterFromJson(jsonString);

import 'dart:convert';

import 'package:tienda/model/category.dart';
import 'package:tienda/model/product.dart';

import 'country.dart';

Presenter presenterFromJson(String str) => Presenter.fromJson(json.decode(str));

String presenterToJson(Presenter data) => json.encode(data.toJson());

class Presenter {
  Presenter({
    this.id,
    this.name,
    this.profilePicture,
    this.headerProfile,
    this.bio,
    this.followers,
    this.isLive,
    this.categoryId,
    this.country,
    this.shortDescription,
    this.countryId,
    this.streamUrl,
    this.m3U8Url,
    this.interests,
    this.featuredProducts,
    this.products,
    this.videos,
    this.isFollowed,
  });

  int id;
  String name;
  String profilePicture;
  String headerProfile;
  String bio;
  int followers;
  bool isLive;
  int categoryId;
  Country country;
  String shortDescription;
  int countryId;
  String streamUrl;
  String m3U8Url;
  List<Category> interests;
  List<Product> featuredProducts;
  int products;
  List<Video> videos;
  bool isFollowed;

  factory Presenter.fromJson(Map<String, dynamic> json) => Presenter(
        id: json["id"],
        name: json["name"],
        profilePicture: json["profile_picture"],
        headerProfile: json["header_profile"],
        bio: json["bio"],
        followers: json["followers"],
        isLive: json["is_live"],
        categoryId: json["category_id"],
        country:
            json["country"] != null ? Country.fromJson(json["country"]) : null,
        shortDescription: json["short_description"],
        countryId: json["country_id"],
        streamUrl: json["stream_url"],
        m3U8Url: json["m3u8_url"],
        interests: json["interests"] != null
            ? List<Category>.from(
                json["interests"].map((x) => Category.fromJson(x)))
            : null,
        featuredProducts: json["featured_products"] != null
            ? List<Product>.from(
                json["featured_products"].map((x) => Product.fromJson(x)))
            : null,
        products: json["products"],
        videos: json["videos"] != null
            ? List<Video>.from(json["videos"].map((x) => Video.fromJson(x)))
            : null,
        isFollowed: json["is_followed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile_picture": profilePicture,
        "header_profile": headerProfile,
        "bio": bio,
        "followers": followers,
        "is_live": isLive,
        "category_id": categoryId,
        "country": country.toJson(),
        "short_description": shortDescription,
        "country_id": countryId,
        "stream_url": streamUrl,
        "m3u8_url": m3U8Url,
        "interests": List<dynamic>.from(interests.map((x) => x.toJson())),
        "featured_products":
            List<Product>.from(featuredProducts.map((x) => x.toJson())),
        "products": products,
        "videos": List<dynamic>.from(videos.map((x) => x.toJson())),
        "is_followed": isFollowed,
      };
}

class Video {
  Video({this.id, this.lastVideo, this.thumbnail});

  int id;
  String lastVideo;
  String thumbnail;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json["id"],
        lastVideo: json["last_video"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() =>
      {"id": id, "last_video": lastVideo, "thumbnail": thumbnail};
}
