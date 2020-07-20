import 'package:equatable/equatable.dart';
import 'package:tienda/model/cart.dart';

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
class AddCartItem extends CartEvents {
  final CartItem cartItem;
  AddCartItem({this.cartItem}) : super();

  @override
  List<Object> get props => [cartItem];
}
class EditCartItem extends CartEvents {
  final CartItem cartItem;
  EditCartItem({this.cartItem}) : super();

  @override
  List<Object> get props => [cartItem];
}

class DeleteCartItem extends CartEvents {
  final CartItem cartItem;
  DeleteCartItem({this.cartItem}) : super();

  @override
  List<Object> get props => [cartItem];
}


class CartCheckOut extends CartEvents {
  final int addressId;
  CartCheckOut({this.addressId}) : super();

  @override
  List<Object> get props => [addressId];
}
