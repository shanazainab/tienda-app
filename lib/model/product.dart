import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:tienda/model/presenter.dart';

class Product extends Equatable {
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
      this.isPurchased,
      this.brand});

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

  int quantity;
  int discount;

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
          categoryId: json["category_id"],
          subCategoryId: json["sub_category_id"],
          thirdCategoryId: json["third_category_id"],
          price: json["price"] != null ? json["price"].toDouble() : 0,
          thumbnail: json["thumbnail"],
          isAvailable: json["is_available"],
          sellerId: json["seller_id"],
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
          brand: json["brand"]);
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
      };
    } catch (e) {
      print('PRODUCT TOJSON CONVERSION ERROR : $e');
    }

    return j;
  }

  @override
  // TODO: implement stringify
  bool get stringify => true;

  @override
  // TODO: implement props
  List<Object> get props => [isWishListed];
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
