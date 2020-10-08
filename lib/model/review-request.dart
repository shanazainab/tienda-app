

import 'dart:convert';
import 'dart:io';

ReviewRequest reviewRequestFromJson(String str) => ReviewRequest.fromJson(json.decode(str));

String reviewRequestToJson(ReviewRequest data) => json.encode(data.toJson());

class ReviewRequest {
  ReviewRequest({
    this.productId,
    this.body,
    this.rating,
    this.isPhotos,
    this.photos,
    this.images
  });

  int productId;
  String body;
  double rating;
  bool isPhotos;
  List<String> photos;
  List<File> images;

  factory ReviewRequest.fromJson(Map<String, dynamic> json) => ReviewRequest(
    productId: json["product_id"],
    body: json["body"],
    rating: json["rating"].toDouble(),
    isPhotos: json["is_photos"],
    photos: List<String>.from(json["photos"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "body": body,
    "rating": rating,
    "is_photos": isPhotos,
    "photos": List<dynamic>.from(photos.map((x) => x)),
  };
}
