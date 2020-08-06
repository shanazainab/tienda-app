import 'package:equatable/equatable.dart';
import 'package:tienda/model/order.dart';

abstract class OrderStates extends Equatable {
  OrderStates();

  @override
  List<Object> get props => null;
}

class Loading extends OrderStates {
  Loading() : super();
}

class LoadOrderDataSuccess extends OrderStates {

  final List<Order> allOrders;
  final List<Order> processingOrders;
  final List<Order> deliveredOrders;

  LoadOrderDataSuccess({this.allOrders,this.processingOrders,this.deliveredOrders}) : super();

  @override
  List<Object> get props => [allOrders,processingOrders,deliveredOrders];
}

class LoadOrderDataFail extends OrderStates {
  final dynamic error;

  LoadOrderDataFail(this.error) : super();

  @override
  List<Object> get props => error;
}
