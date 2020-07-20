

import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:tienda/model/product.dart';

List<Order> orderFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  Order({
    this.id,
    this.customerId,
    this.createdAt,
    this.status,
    this.summaryPrice,
    this.address,
    this.addressData,
    this.totalPrice,
    this.numberOfItems,
    this.cartUuid,
    this.orderUuid,
    this.products,
  });

  int id;
  int customerId;
  DateTime createdAt;
  String status;
  double summaryPrice;
  String address;
  String addressData;
  double totalPrice;
  int numberOfItems;
  String cartUuid;
  String orderUuid;
  List<Product> products;

  factory Order.fromJson(Map<String, dynamic> json){

    Order order;
    try {
    order = Order(
       id: json["id"],
       customerId: json["customer_id"],
       createdAt: DateTime.parse(json["created_at"]),
       status: json["status"],
       summaryPrice: json["summary_price"].toDouble(),
       address: json["address"],
       addressData: json["address_data"],
       totalPrice: json["total_price"].toDouble(),
       numberOfItems: json["number_of_items"],
       cartUuid: json["cart_UUID"],
       orderUuid: json["order_UUID"],
       products: List<Product>.from(
           json["products"].map((x) => Product.fromJson(x))),
     );
   }catch(err){
     Logger().e("ERROR FROM ORDER: $err");
   }

    return order;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_id": customerId,
    "created_at": createdAt.toIso8601String(),
    "status": status,
    "summary_price": summaryPrice,
    "address": address,
    "address_data": addressData,
    "total_price": totalPrice,
    "number_of_items": numberOfItems,
    "cart_UUID": cartUuid,
    "order_UUID": orderUuid,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}
