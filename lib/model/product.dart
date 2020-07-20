import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

class Product extends Equatable {
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
    this.sellerId,
    this.totalReviews,
    this.overallRating,
    this.isWishListed,
    this.images,
    this.specs,
    this.reviews,
    this.ratings,
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
  dynamic sellerId;
  int totalReviews;
  double overallRating;
  bool isWishListed;
  List<String> images;
  List<Spec> specs;
  List<Review> reviews;
  Map<String, int> ratings;

  factory Product.fromJson(Map<String, dynamic> json) {
    Product product;
    try {
      product = Product(
        id: json["id"],
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
            ? List<Review>.from(json["reviews"].map((x) => Review.fromJson(x)))
            : null,
        ratings: json["ratings"] != null
            ? Map.from(json["ratings"])
                .map((k, v) => MapEntry<String, int>(k, v))
            : null,
      );
    } catch (err) {
      Logger().e(err);
    }

    return product;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_ar": nameAr,
        "name_en": nameEn,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "third_category_id": thirdCategoryId,
        "price": price,
        "thumbnail": thumbnail,
        "is_available": isAvailable,
        "seller_id": sellerId,
        "images": List<dynamic>.from(images.map((x) => x)),
        "specs": List<dynamic>.from(specs.map((x) => x.toJson())),
        "total_reviews": totalReviews,
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
        "overall_rating": overallRating,
        "ratings":
            Map.from(ratings).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };

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
  });

  DateTime createdAt;
  double rating;
  String body;
  String customerName;
  String elapsedTime;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        createdAt: DateTime.parse(json["created_at"]),
        rating: json["rating"].toDouble(),
        body: json["body"],
        customerName: json["customer_name"],
        elapsedTime: json["elapsed_time"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt.toIso8601String(),
        "rating": rating,
        "body": body,
        "customer_name": customerName,
        "elapsed_time": elapsedTime,
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
