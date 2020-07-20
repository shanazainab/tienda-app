// To parse this JSON data, do
//
//     final productListResponse = productListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:tienda/model/product.dart';

ProductListResponse productListResponseFromJson(String str) =>
    ProductListResponse.fromJson(json.decode(str));

String productListResponseToJson(ProductListResponse data) =>
    json.encode(data.toJson());

class ProductListResponse {
  ProductListResponse({
    this.status,
    this.products,
    this.catId,
    this.productsCount,
    this.navigator,
  });

  int status;
  List<Product> products;
  int catId;
  int productsCount;
  Navigator navigator;

  factory ProductListResponse.fromJson(Map<String, dynamic> json) =>
      ProductListResponse(
        status: json["status"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        catId: json["cat_id"],
        productsCount: json["products_count"],
        navigator: Navigator.fromJson(json["navigator"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "cat_id": catId,
        "products_count": productsCount,
        "navigator": navigator.toJson(),
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
