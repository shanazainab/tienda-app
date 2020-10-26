// To parse this JSON data, do
//
//     final homeScreenResponse = homeScreenResponseFromJson(jsonString);

import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:tienda/model/category.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/model/product.dart';

HomeScreenResponse homeScreenResponseFromJson(String str) =>
    HomeScreenResponse.fromJson(json.decode(str));

String homeScreenResponseToJson(HomeScreenResponse data) =>
    json.encode(data.toJson());

class HomeScreenResponse {
  HomeScreenResponse({
    this.status,
    this.featuredPresenters,
    this.topCategories,
    this.dealsOfTheDay,
    this.recommendedProducts,
    this.newArrivals,
    this.featuredBrands,
    this.liveStreams,
  });

  int status;
  List<Presenter> featuredPresenters;
  List<Category> topCategories;
  List<Product> dealsOfTheDay;
  List<Product> recommendedProducts;
  List<Product> newArrivals;
  List<FeaturedBrand> featuredBrands;
  List<LiveStream> liveStreams;

  factory HomeScreenResponse.fromJson(Map<String, dynamic> json) {
    HomeScreenResponse homeScreenResponse;
    try {
      homeScreenResponse = HomeScreenResponse(
        status: json["status"],
        featuredPresenters: List<Presenter>.from(
            json["featured_presenters"].map((x) => Presenter.fromJson(x))),
        topCategories: List<Category>.from(
            json["top_categories"].map((x) => Category.fromJson(x))),
        dealsOfTheDay: List<Product>.from(
            json["deals_of_the_day"].map((x) => Product.fromJson(x))),
        recommendedProducts: List<Product>.from(
            json["recommended_products"].map((x) => Product.fromJson(x))),
        newArrivals: List<Product>.from(
            json["new_arrivals"].map((x) => Product.fromJson(x))),
        featuredBrands: List<FeaturedBrand>.from(
            json["featured_brands"].map((x) => FeaturedBrand.fromJson(x))),
        liveStreams: List<LiveStream>.from(
            json["live_streams"].map((x) => LiveStream.fromJson(x))),
      );
    } catch (e) {
      Logger().e(e);
    }
    return homeScreenResponse;
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "featured_presenters":
            List<dynamic>.from(featuredPresenters.map((x) => x.toJson())),
        "top_categories":
            List<dynamic>.from(topCategories.map((x) => x.toJson())),
        "deals_of_the_day":
            List<dynamic>.from(dealsOfTheDay.map((x) => x.toJson())),
        "recommended_products":
            List<dynamic>.from(recommendedProducts.map((x) => x.toJson())),
        "new_arrivals": List<dynamic>.from(newArrivals.map((x) => x.toJson())),
        "featured_brands":
            List<dynamic>.from(featuredBrands.map((x) => x.toJson())),
        "live_streams": List<dynamic>.from(liveStreams.map((x) => x.toJson())),
      };
}

class FeaturedBrand {
  FeaturedBrand({
    this.brand,
  });

  String brand;

  factory FeaturedBrand.fromJson(Map<String, dynamic> json) => FeaturedBrand(
        brand: json["brand"],
      );

  Map<String, dynamic> toJson() => {
        "brand": brand,
      };
}

class LiveStream {
  LiveStream({
    this.presenterName,
    this.presenterProfilePicture,
    this.thumbnail,
    this.liveTime,
    this.isLive,
  });

  String presenterName;
  String presenterProfilePicture;
  String thumbnail;
  DateTime liveTime;
  bool isLive;

  factory LiveStream.fromJson(Map<String, dynamic> json) => LiveStream(
        presenterName: json["presenter__name"],
        presenterProfilePicture: json["presenter__profile_picture"],
        thumbnail: json["thumbnail"],
        liveTime: DateTime.parse(json["live_time"]),
        isLive: json["is_live"],
      );

  Map<String, dynamic> toJson() => {
        "presenter__name": presenterName,
        "presenter__profile_picture": presenterProfilePicture,
        "thumbnail": thumbnail,
        "live_time": liveTime.toIso8601String(),
        "is_live": isLive,
      };
}
