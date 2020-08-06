import 'package:equatable/equatable.dart';
import 'package:tienda/model/order.dart';

abstract class CheckoutStates {
  CheckoutStates();

}

class Loading extends CheckoutStates {
  Loading() : super();
}

class InitialCheckOutSuccess extends CheckoutStates {
  InitialCheckOutSuccess() : super();

}

class AddressActive extends CheckoutStates {
  final String status;
  final Order order;
  AddressActive(this.status,this.order) : super();

}
class PaymentActive extends CheckoutStates {
  final String status;
  final Order order;
  PaymentActive(this.status,this.order) : super();

}
class CartActive extends CheckoutStates {
  final String status;
  final Order order;
  CartActive(this.status,this.order) : super();

}

