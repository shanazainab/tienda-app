// To parse this JSON data, do
//
//     final searchBody = searchBodyFromJson(jsonString);

import 'dart:convert';

SearchBody searchBodyFromJson(String str) =>
    SearchBody.fromJson(json.decode(str));

String searchBodyToJson(SearchBody data) => json.encode(data.toJson());

class SearchBody {
  static const String PRICE_HIGH_LOW = "price_high_low";
  static const String PRICE_LOW_HIGH = "price_low_high";
  static const String RATING_HIGH_LOW = "rating_high_low";

  SearchBody({
    this.priceGt,
    this.priceLt,
    this.category,
    this.sortBy,
    this.brands,
  });

  int priceGt;
  int priceLt;
  int category;
  String sortBy;
  List<String> brands = new List();

  factory SearchBody.fromJson(Map<String, dynamic> json) => SearchBody(
        priceGt: json["price_gt"],
        priceLt: json["price_lt"],
        category: json["category"],
        sortBy: json["sort_by"],
        brands: List<String>.from(json["brands"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        if (priceGt != null) "price_gt": priceGt,
        if (priceLt != null) "price_lt": priceLt,
        if (category != null) "category": category,
        if (sortBy != null) "sort_by": sortBy,
        if (brands != null && brands.isNotEmpty)
          "brands": List<dynamic>.from(brands.map((x) => x)),
      };
}
