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

  final List<Order> orders;

  LoadOrderDataSuccess(this.orders) : super();

  @override
  List<Object> get props => orders;
}

class LoadOrderDataFail extends OrderStates {
  final dynamic error;

  LoadOrderDataFail(this.error) : super();

  @override
  List<Object> get props => error;
}