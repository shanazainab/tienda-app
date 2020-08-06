import 'package:equatable/equatable.dart';
import 'package:tienda/model/order.dart';

abstract class OrderEvents extends Equatable {
  OrderEvents();

  @override
  List<Object> get props => null;
}

class LoadOrders extends OrderEvents {
  LoadOrders() : super();

  @override
  List<Object> get props => [];
}

class CancelOrder extends OrderEvents {
  final List<Order> allOrders;
  final List<Order> processingOrders;
  final List<Order> deliveredOrders;

  final int orderId;
  CancelOrder(this.orderId,{this.allOrders,this.processingOrders,this.deliveredOrders}) : super();

  @override
  List<Object> get props => [orderId];
}
