import 'package:equatable/equatable.dart';

abstract class CheckoutEvents extends Equatable {
  CheckoutEvents();

  @override
  List<Object> get props => null;
}

class DoCartCheckout extends CheckoutEvents {
  final int addressId;

  DoCartCheckout({this.addressId}) : super();

  @override
  List<Object> get props => [addressId];
}