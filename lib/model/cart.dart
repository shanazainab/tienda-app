import 'dart:convert';

import 'package:tienda/model/product.dart';

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toJson());

class Cart {
  List<Product> products;
  double cartPrice;
  double totalDiscount;

  Cart({this.products, this.cartPrice, this.totalDiscount});

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        products: List<Product>.from(
            json["cart"].map((x) => Product.fromJson(x))),
    cartPrice: json['total_price']
      );

  Map<String, dynamic> toJson() => {
    'total_price':cartPrice,
        "cart": List<dynamic>.from(products.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'Cart{products: $products, cartPrice: $cartPrice, totalDiscount: $totalDiscount}';
  }
}
