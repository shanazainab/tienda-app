import 'package:equatable/equatable.dart';
import 'package:tienda/model/cart.dart';
import 'package:tienda/model/product.dart';

abstract class CartEvents extends Equatable {
  CartEvents();

  @override
  List<Object> get props => null;
}

class FetchCartData extends CartEvents {
  FetchCartData() : super();

  @override
  List<Object> get props => [];
}

class OfflineLoadCart extends CartEvents {
  OfflineLoadCart() : super();

  @override
  List<Object> get props => [];
}

class AddCartItem extends CartEvents {
  final Cart cart;
  final Product cartItem;

  AddCartItem({this.cart, this.cartItem}) : super();

  @override
  List<Object> get props => [cartItem];
}

class EditCartItem extends CartEvents {
  final Cart cart;
  final String editType;
  final Product cartItem;

  EditCartItem({this.cartItem, this.editType, this.cart}) : super();

  @override
  List<Object> get props => [cartItem];
}

class DeleteCartItem extends CartEvents {
  final Cart cart;
  final Product cartItem;

  DeleteCartItem({this.cartItem, this.cart}) : super();

  @override
  List<Object> get props => [cartItem];
}

class CartCheckOut extends CartEvents {
  final int addressId;

  CartCheckOut({this.addressId}) : super();

  @override
  List<Object> get props => [addressId];
}

class ClearCart extends CartEvents {
  ClearCart() : super();

  @override
  List<Object> get props => [];
}
