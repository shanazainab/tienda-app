import 'package:tienda/model/product.dart';

class Orders {
  String orderNumber;
  List<Order> orderList;
}

class Order {
  String orderId;
  Product product;
  int quantity;
  String size;
  double orderTotal;
  double discountTotal;
  DateTime orderDate;
  String orderStatus;
}
