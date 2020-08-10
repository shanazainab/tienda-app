// To parse this JSON data, do
//
//     final liveResponse = liveResponseFromJson(jsonString);

import 'dart:convert';

LiveResponse liveResponseFromJson(String str) => LiveResponse.fromJson(json.decode(str));

String liveResponseToJson(LiveResponse data) => json.encode(data.toJson());

class LiveResponse {
  LiveResponse({
    this.status,
    this.isLive,
    this.products,
    this.url,
  });

  int status;
  bool isLive;
  List<Product> products;
  String url;

  factory LiveResponse.fromJson(Map<String, dynamic> json) => LiveResponse(
    status: json["status"],
    isLive: json["is_live"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "is_live": isLive,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "url": url,
  };
}

class Product {
  Product({
    this.id,
    this.nameAr,
    this.nameEn,
    this.categoryId,
    this.subCategoryId,
    this.thirdCategoryId,
    this.price,
    this.thumbnail,
    this.isAvailable,
    this.presenterId,
    this.brand,
    this.discount,
    this.isReturnable,
    this.lastVideo,
  });

  int id;
  String nameAr;
  String nameEn;
  int categoryId;
  int subCategoryId;
  int thirdCategoryId;
  double price;
  String thumbnail;
  bool isAvailable;
  int presenterId;
  String brand;
  int discount;
  bool isReturnable;
  String lastVideo;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    nameAr: json["name_ar"],
    nameEn: json["name_en"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"] == null ? null : json["sub_category_id"],
    thirdCategoryId: json["third_category_id"],
    price: json["price"].toDouble(),
    thumbnail: json["thumbnail"],
    isAvailable: json["is_available"],
    presenterId: json["presenter_id"],
    brand: json["brand"],
    discount: json["discount"],
    isReturnable: json["is_returnable"],
    lastVideo: json["last_video"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_ar": nameAr,
    "name_en": nameEn,
    "category_id": categoryId,
    "sub_category_id": subCategoryId == null ? null : subCategoryId,
    "third_category_id": thirdCategoryId,
    "price": price,
    "thumbnail": thumbnail,
    "is_available": isAvailable,
    "presenter_id": presenterId,
    "brand": brand,
    "discount": discount,
    "is_returnable": isReturnable,
    "last_video": lastVideo,
  };
}
