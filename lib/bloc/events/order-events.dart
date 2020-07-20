import 'package:equatable/equatable.dart';

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
