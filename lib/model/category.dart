// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    this.id,
    this.nameEn,
    this.nameAr,
    this.thumbnail,
    this.subCats,
  });

  int id;
  String nameEn;
  String nameAr;
  String thumbnail;
  List<SubCat> subCats;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    nameEn: json["name_en"],
    nameAr: json["name_ar"],
    thumbnail: json["thumbnail"],
    subCats: List<SubCat>.from(json["sub_cats"].map((x) => SubCat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_en": nameEn,
    "name_ar": nameAr,
    "thumbnail": thumbnail,
    "sub_cats": List<dynamic>.from(subCats.map((x) => x.toJson())),
  };
}

class SubCat {
  SubCat({
    this.id,
    this.categoryId,
    this.nameEn,
    this.nameAr,
    this.thirdLevel,
  });

  int id;
  int categoryId;
  String nameEn;
  String nameAr;
  List<SubSubCat> thirdLevel;

  factory SubCat.fromJson(Map<String, dynamic> json) => SubCat(
    id: json["id"],
    categoryId: json["category_id"],
    nameEn: json["name_en"],
    nameAr: json["name_ar"],
    thirdLevel: json["third_level"] == null ? null : List<SubSubCat>.from(json["third_level"].map((x) => SubSubCat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "name_en": nameEn,
    "name_ar": nameAr,
    "third_level": thirdLevel == null ? null : List<dynamic>.from(thirdLevel.map((x) => x.toJson())),
  };
}

class SubSubCat {
  SubSubCat({
    this.id,
    this.categoryId,
    this.nameEn,
    this.nameAr,
  });

  int id;
  int categoryId;
  String nameEn;
  String nameAr;

  factory SubSubCat.fromJson(Map<String, dynamic> json) => SubSubCat(
    id: json["id"],
    categoryId: json["category_id"],
    nameEn: json["name_en"],
    nameAr: json["name_ar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "name_en": nameEn,
    "name_ar": nameAr,
  };
}
