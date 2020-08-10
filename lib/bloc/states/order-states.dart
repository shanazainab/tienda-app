import 'package:tienda/model/order.dart';

abstract class OrderStates {
  OrderStates();
}

class Loading extends OrderStates {
  Loading() : super();
}

class LoadOrderDataSuccess extends OrderStates {
  final List<Order> allOrders;

  LoadOrderDataSuccess({this.allOrders}) : super();
}

class LoadOrderDataFail extends OrderStates {
  final dynamic error;

  LoadOrderDataFail(this.error) : super();
}

class CancelOrderSuccess extends OrderStates {
  CancelOrderSuccess() : super();
}

class ReturnOrderSuccess extends OrderStates {
  ReturnOrderSuccess() : super();
}

class FetchReturnOrdersSuccess extends OrderStates {
  final List<Order> returnOrders;

  FetchReturnOrdersSuccess(this.returnOrders) : super();
}
