import 'package:equatable/equatable.dart';
import 'package:tienda/model/wishlist.dart';

abstract class WishListEvents extends Equatable {
  WishListEvents();

  @override
  List<Object> get props => null;
}

class LoadWishListProducts extends WishListEvents {
  final WishList wishList;

  LoadWishListProducts({this.wishList}) : super();

  @override
  List<Object> get props => [wishList];
}

class AddToWishList extends WishListEvents {
  final WishListItem wishListItem;

  AddToWishList({this.wishListItem}) : super();

  @override
  List<Object> get props => [wishListItem];
}

class DeleteWishListItem extends WishListEvents {
  final WishListItem wishListItem;

  DeleteWishListItem({this.wishListItem}) : super();

  @override
  List<Object> get props => [wishListItem];
}