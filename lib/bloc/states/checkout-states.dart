import 'package:equatable/equatable.dart';

abstract class CheckoutStates extends Equatable {
  CheckoutStates();

  @override
  List<Object> get props => null;
}

class Loading extends CheckoutStates {
  Loading() : super();
}

class InitialCheckOutSuccess extends CheckoutStates {


  InitialCheckOutSuccess() : super();

  @override
  List<Object> get props => [];
}
