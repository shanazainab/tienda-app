// To parse this JSON data, do
//
//     final presenter = presenterFromJson(jsonString);

import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:tienda/model/product.dart';

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
    this.shortDescription,
    this.videos,
    this.popularVideos,
    this.featuredProducts,
    this.isFollowed,
    this.products
  });
  int products;

  int id;
  String name;
  String profilePicture;
  String headerProfile;
  String bio;
  int followers;
  bool isLive;
  int categoryId;
  String shortDescription;
  int videos;
  List<dynamic> popularVideos;
  List<Product> featuredProducts;
  bool isFollowed;

  factory Presenter.fromJson(Map<String, dynamic> json) {
    Presenter presenter;
    try {
      presenter = Presenter(
        id: json["id"],
        name: json["name"],
        profilePicture: json["profile_picture"],
        headerProfile: json["header_profile"],
        bio: json["bio"],
        products: json["products"],
        followers: json["followers"],
        isLive: json["is_live"],
        categoryId: json["category_id"],
        shortDescription: json["short_description"],
        videos: json["videos"],
        popularVideos: json["popular_videos"] != null
            ? List<dynamic>.from(json["popular_videos"].map((x) => x))
            : null,
        featuredProducts: json["featured_products"]!=null?List<Product>.from(
            json["featured_products"].map((x) => Product.fromJson(x))):null,
        isFollowed: json["is_followed"],
      );
    } catch (err) {
      Logger().e(err);
    }
    return presenter;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
    "products": products,
    "name": name,
        "profile_picture": profilePicture,
        "header_profile": headerProfile,
        "bio": bio,
        "followers": followers,
        "is_live": isLive,
        "category_id": categoryId,
        "short_description": shortDescription,
        "videos": videos,
        "popular_videos": List<dynamic>.from(popularVideos.map((x) => x)),
        "featured_products": List<dynamic>.from(featuredProducts.map((x) => x)),
        "is_followed": isFollowed,
      };
}
