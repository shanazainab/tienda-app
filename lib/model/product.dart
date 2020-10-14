import 'dart:io';

import 'package:logger/logger.dart';
import 'package:tienda/model/presenter.dart';

class Product{
  Product(
      {this.id,
      this.quantity,
      this.nameAr,
      this.nameEn,
      this.categoryId,
      this.subCategoryId,
      this.thirdCategoryId,
      this.price,
      this.thumbnail,
      this.isAvailable,
      this.sellerId,
      this.totalReviews,
      this.overallRating,
      this.isWishListed,
      this.images,
      this.specs,
      this.reviews,
      this.ratings,
      this.isReviewed,
      this.discount,
      this.presenter,
        this.colors,
        this.sizes,
      this.isPurchased,
        this.coupon,
      this.brand,this.isReturnable,this.lastVideo,this.isRated});

  int id;
  String brand;
  String nameAr;
  String nameEn;
  int categoryId;
  int subCategoryId;
  int thirdCategoryId;
  double price;
  String thumbnail;
  bool isAvailable;
  dynamic sellerId;
  int totalReviews;
  double overallRating;
  bool isWishListed;
  List<String> images;
  List<Spec> specs;
  List<Review> reviews;
  Map<String, int> ratings;
  bool isReviewed;
  bool isPurchased;
  bool isRated;
  List<ProductColor> colors;
  List<ProductSize> sizes;
  String lastVideo;
  bool isReturnable;
  int quantity;
  int discount;
  Coupon coupon;

  Presenter presenter;

  factory Product.fromJson(Map<String, dynamic> json) {
    Product product;
    try {
      product = Product(
          id: json["id"],
          presenter: json["presenter"] != null
              ? Presenter.fromJson(json["presenter"])
              : null,
          nameAr: json["name_ar"],
          nameEn: json["name_en"],
          coupon: json["coupon"]!=null?Coupon.fromJson(json["coupon"]):null,
          categoryId: json["category_id"],
          subCategoryId: json["sub_category_id"],
          thirdCategoryId: json["third_category_id"],
          price: json["price"] != null ? json["price"].toDouble() : 0,
          thumbnail: json["thumbnail"],
          isAvailable: json["is_available"],
          sellerId: json["seller_id"],
          colors: json["colors"] != null?List<ProductColor>.from(json["colors"].map((x) => ProductColor.fromJson(x))):null,
          sizes: json["sizes"]!= null?List<ProductSize>.from(json["sizes"].map((x) => ProductSize.fromJson(x))):null,
          totalReviews: json["total_reviews"],
          discount: json["discount"],
          isReviewed: json["is_reviewed"],
          isPurchased: json["is_purchased"],
          overallRating: json["overall_rating"] != null
              ? json["overall_rating"].toDouble()
              : 0.0,
          images: json["images"] != null
              ? List<String>.from(json["images"].map((x) => x))
              : null,
          specs: json["specs"] != null
              ? List<Spec>.from(json["specs"].map((x) => Spec.fromJson(x)))
              : null,
          reviews: json["reviews"] != null
              ? List<Review>.from(
                  json["reviews"].map((x) => Review.fromJson(x)))
              : null,
          ratings: json["ratings"] != null
              ? Map.from(json["ratings"])
                  .map((k, v) => MapEntry<String, int>(k, v))
              : null,
          quantity: json['quantity'],
          brand: json["brand"],
      isReturnable: json["is_returnable"],
      isRated: json['is_rated'],
      lastVideo: json["last_video"]);
    } catch (err) {
      Logger().e(err);
    }

    return product;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> j;
    try {
      j = {
        "id": id,
        "presenter": presenter != null ? presenter.toJson() : null,
        "name_ar": nameAr,
        "name_en": nameEn,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "third_category_id": thirdCategoryId,
        "price": price,
        "is_reviewed": isReviewed,
        "thumbnail": thumbnail,
        "is_available": isAvailable,
        "seller_id": sellerId,
        "is_purchased": isPurchased,
        'quantity': quantity,
        "images":
            images != null ? List<dynamic>.from(images.map((x) => x)) : null,
        "specs": specs != null
            ? List<dynamic>.from(specs.map((x) => x.toJson()))
            : null,
        "total_reviews": totalReviews,
        "reviews": reviews != null
            ? List<dynamic>.from(reviews.map((x) => x.toJson()))
            : null,
        "overall_rating": overallRating,
        "brand": brand,
        "discount": discount,
        "ratings": ratings != null
            ? Map.from(ratings).map((k, v) => MapEntry<String, dynamic>(k, v))
            : null,
        "is_returnable":isReturnable,
        "is_rated":isRated,
        "last_video":lastVideo
      };
    } catch (e) {
      print('PRODUCT TOJSON CONVERSION ERROR : $e');
    }

    return j;
  }

  @override
  String toString() {
    return 'Product{lastVideo: $lastVideo}';
  }

// @override
  // // TODO: implement stringify
  // bool get stringify => true;
  //
  // @override
  // // TODO: implement props
  // List<Object> get props => [isWishListed];
}

class Review {
  Review({
    this.createdAt,
    this.rating,
    this.body,
    this.customerName,
    this.elapsedTime,
    this.images,
    this.fileImages,
  });

  List<Image> images;

  DateTime createdAt;
  double rating;
  String body;
  String customerName;
  String elapsedTime;
  List<File> fileImages;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        createdAt: DateTime.parse(json["created_at"]),
        rating: json["rating"].toDouble(),
        body: json["body"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        customerName: json["customer_name"],
        elapsedTime: json["elapsed_time"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt.toIso8601String(),
        "rating": rating,
        "body": body,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "customer_name": customerName,
        "elapsed_time": elapsedTime,
      };

  @override
  String toString() {
    return 'Review{images: $images, fileImages: $fileImages}';
  }
}
class ProductColor {
  ProductColor({
    this.colorHex,
    this.id,
  });

  String colorHex;
  int id;

  factory ProductColor.fromJson(Map<String, dynamic> json) => ProductColor(
    colorHex: json["color_hex"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "color_hex": colorHex,
    "id": id,
  };
}
class Image {
  Image({
    this.image,
  });

  String image;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
      };
}
class ProductSize {
  ProductSize({
    this.size,
    this.id,
  });

  String size;
  int id;

  factory ProductSize.fromJson(Map<String, dynamic> json) => ProductSize(
    size: json["size"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "size": size,
    "id": id,
  };
}
class Coupon {
  Coupon({
    this.id,
    this.name,
    this.description,
    this.type,
    this.value,
    this.code,
  });

  int id;
  String name;
  String description;
  String type;
  String value;
  String code;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    type: json["type"],
    value: json["value"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "type": type,
    "value": value,
    "code": code,
  };
}

class Spec {
  Spec({
    this.id,
    this.productId,
    this.key,
    this.value,
  });

  int id;
  int productId;
  String key;
  String value;

  factory Spec.fromJson(Map<String, dynamic> json) => Spec(
        id: json["id"],
        productId: json["product_id"],
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "key": key,
        "value": value,
      };
}
