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

  final bool isLoggedIn;

  final bool isFromLiveStream;

  final int presenterId;
  AddCartItem({this.cart, this.cartItem, this.isLoggedIn,this.isFromLiveStream,this.presenterId}) : super();

  @override
  List<Object> get props => [cartItem];
}

class EditCartItem extends CartEvents {
  final Cart cart;
  final String editType;
  final Product cartItem;
  final bool isLoggedIn;

  EditCartItem({this.cartItem, this.editType, this.cart, this.isLoggedIn})
      : super();

  @override
  List<Object> get props => [cartItem];
}

class DeleteCartItem extends CartEvents {
  final Cart cart;
  final Product cartItem;
  final bool isLoggedIn;

  DeleteCartItem({this.cartItem, this.cart, this.isLoggedIn}) : super();

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

class ApplyCoupon extends CartEvents {
  final String couponCode;

  ApplyCoupon(this.couponCode) : super();

  @override
  List<Object> get props => [];
}

class RemoveCoupon extends CartEvents {
  final String couponCode;

  RemoveCoupon(this.couponCode) : super();

  @override
  List<Object> get props => [];
}