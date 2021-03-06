import 'package:equatable/equatable.dart';
import 'package:tienda/model/cart.dart';

abstract class CartStates extends Equatable {
  CartStates();

  @override
  List<Object> get props => null;
}

class Initialized extends CartStates {
  Initialized() : super();

  @override
  List<Object> get props => [];
}

class LoadCartSuccess extends CartStates {
  final Cart cart;

  LoadCartSuccess({this.cart}) : super();

  @override
  List<Object> get props => [cart];
}

class LoadCartFail extends CartStates {
  final dynamic error;

  LoadCartFail(this.error) : super();

  @override
  List<Object> get props => error;
}
class ProductAlreadyInCart extends CartStates {


  ProductAlreadyInCart() : super();

  @override
  List<Object> get props => [];
}

class EmptyCart extends CartStates {
  EmptyCart() : super();

  @override
  List<Object> get props => [];
}

class AddToCartSuccess extends CartStates {
  final Cart addedCart;
  AddToCartSuccess({this.addedCart}) : super();

  @override
  List<Object> get props => [addedCart];
}

class EditCartItemSuccess extends CartStates {
  EditCartItemSuccess() : super();

  @override
  List<Object> get props => [];
}

class DeleteCartItemSuccess extends CartStates {
  final Cart cart;
  DeleteCartItemSuccess({this.cart}) : super();

  @override
  List<Object> get props => [];
}
