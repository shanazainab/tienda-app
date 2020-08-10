import 'package:tienda/model/order.dart';

abstract class OrderEvents {
  OrderEvents();
}

class LoadOrders extends OrderEvents {
  LoadOrders() : super();
}

class CancelOrder extends OrderEvents {

  final Order order;

  CancelOrder(this.order) : super();
}

class ReturnOrder extends OrderEvents {

  final Order order;

  ReturnOrder(this.order) : super();
}

class FetchReturnOrders extends OrderEvents {
  FetchReturnOrders() : super();
}
