import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:tienda/model/product.dart';

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toJson());

class Cart {
  List<Product> products;

  Summary summary;

  Cart({this.products, this.summary});

  factory Cart.fromJson(Map<String, dynamic> json) {
    Cart cart;
    try {
      cart = Cart(
          products:
              List<Product>.from(json["cart"].map((x) => Product.fromJson(x))),
          summary: Summary.fromJson(json['summary']));
    } catch (e) {
      Logger().e(e);
    }
    return cart;
  }

  Map<String, dynamic> toJson() => {
        'summary': summary.toJson(),
        "cart": List<dynamic>.from(products.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'Cart{products: $products, summary: $summary}';
  }
}

class Summary {
  Summary({
    this.totalPrice,
    this.discountPrice,
    this.numberOfItems,
    this.cartStatus,
    this.isCoupon,
    this.appliedCoupon,
  });

  double totalPrice;
  double discountPrice;
  int numberOfItems;
  String cartStatus;
  bool isCoupon;
  Coupon appliedCoupon;

  factory Summary.fromJson(Map<String, dynamic> json) {
    Summary summary;
    try {
      summary = Summary(
        totalPrice: json["total_price"].toDouble(),
        discountPrice: json["discount_price"],
        numberOfItems: json["number_of_items"],
        cartStatus: json["cart_status"],
        isCoupon: json["is_coupon"],
        appliedCoupon: Coupon.fromJson(json["applied_coupon"]),
      );
    } catch (e) {
      Logger().e(e);
    }
    return summary;
  }

  Map<String, dynamic> toJson() => {
        "total_price": totalPrice,
        "discount_price": discountPrice,
        "number_of_items": numberOfItems,
        "cart_status": cartStatus,
        "is_coupon": isCoupon,
        "applied_coupon": appliedCoupon.toJson(),
      };
}

class AppliedCoupon {
  AppliedCoupon();

  factory AppliedCoupon.fromJson(Map<String, dynamic> json) => AppliedCoupon();

  Map<String, dynamic> toJson() => {};
}
