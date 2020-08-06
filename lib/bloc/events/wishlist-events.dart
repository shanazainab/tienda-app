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

class OfflineLoadWishList extends WishListEvents {
  OfflineLoadWishList() : super();

  @override
  List<Object> get props => [];
}

class AddToWishList extends WishListEvents {
  final WishListItem wishListItem;

  AddToWishList({this.wishListItem}) : super();

  @override
  List<Object> get props => [wishListItem];
}

class DeleteWishListItem extends WishListEvents {
  final WishList wishList;
  final WishListItem wishListItem;

  DeleteWishListItem({this.wishList, this.wishListItem}) : super();

  @override
  List<Object> get props => [wishListItem];
}
