import 'package:equatable/equatable.dart';
import 'package:tienda/model/order.dart';

abstract class CheckoutEvents extends Equatable {
  CheckoutEvents();

  @override
  List<Object> get props => null;
}

class Initialize extends CheckoutEvents {
  Initialize() : super();

  @override
  List<Object> get props => [];
}

class DoCartCheckout extends CheckoutEvents {
  final int addressId;

  DoCartCheckout({this.addressId}) : super();

  @override
  List<Object> get props => [addressId];
}

class DoUpdateCheckOutProgress extends CheckoutEvents {
  final Order order;
  final String status;

  DoUpdateCheckOutProgress({this.status, this.order}) : super();

  @override
  List<Object> get props => [status];
}
