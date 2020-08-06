// To parse this JSON data, do
//
//     final productListResponse = productListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tienda/model/product.dart';

ProductListResponse productListResponseFromJson(String str) =>
    ProductListResponse.fromJson(json.decode(str));

String productListResponseToJson(ProductListResponse data) =>
    json.encode(data.toJson());

class ProductListResponse {
  ProductListResponse(
      {this.status,
      this.products,
      this.catId,
      this.productsCount,
      this.navigator,
      this.filters});

  int status;
  List<Product> products;
  int catId;
  int productsCount;
  Navigator navigator;
  List<Filter> filters;

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    ProductListResponse response;
    try {
      response = ProductListResponse(
        filters: json["filters"] != null
            ? List<Filter>.from(json["filters"].map((x) => Filter.fromJson(x)))
            : null,
        status: json["status"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        catId: json["cat_id"],
        productsCount: json["products_count"],
        navigator: json["navigator"] != null
            ? Navigator.fromJson(json["navigator"])
            : null,
      );
    } catch (e) {
      Logger().e("PRD: $e");
    }

    return response;
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "cat_id": catId,
        "products_count": productsCount,
        "navigator": navigator.toJson(),
        "filters": List<dynamic>.from(filters.map((x) => x.toJson())),
      };
}

class Navigator {
  Navigator({
    this.pages,
    this.nextPage,
  });

  int pages;
  String nextPage;

  factory Navigator.fromJson(Map<String, dynamic> json) => Navigator(
        pages: json["pages"],
        nextPage: json["next_page"],
      );

  Map<String, dynamic> toJson() => {
        "pages": pages,
        "next_page": nextPage,
      };
}

class Filter {
  Filter({this.filterName, this.values, this.chosen});

  String filterName;
  List<Value> values;

  bool chosen;

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        filterName: json["filter_name"],
        values: List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "filter_name": filterName,
        "values": List<dynamic>.from(values.map((x) => x.toJson())),
      };
}

class Value {
  Value(
      {this.brandName,
      this.brandCount,
      this.maxPrice,
      this.minPrice,
      this.discount,
      this.chosen,
      this.chosenMaxPrice,
      this.chosenMinPrice,
      this.count});

  String brandName;
  int discount;
  int count;
  int brandCount;
  double maxPrice;
  double minPrice;
  bool chosen;
  double chosenMinPrice;
  double chosenMaxPrice;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        discount: json["discount"] == null ? null : json["discount"],
        count: json["count"] == null ? null : json["count"],
        brandName: json["brand_name"] == null ? null : json["brand_name"],
        brandCount: json["brand_count"] == null ? null : json["brand_count"],
        maxPrice:
            json["max_price"] == null ? null : json["max_price"].toDouble(),
        minPrice:
            json["min_price"] == null ? null : json["min_price"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "discount": discount == null ? null : discount,
        "count": count == null ? null : count,
        "brand_name": brandName == null ? null : brandName,
        "brand_count": brandCount == null ? null : brandCount,
        "max_price": maxPrice == null ? null : maxPrice,
        "min_price": minPrice == null ? null : minPrice,
      };
}
