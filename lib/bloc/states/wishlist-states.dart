import 'package:equatable/equatable.dart';
import 'package:tienda/model/wishlist.dart';

abstract class WishListStates extends Equatable {
  WishListStates();

  @override
  List<Object> get props => null;
}

class Loading extends WishListStates {
  Loading() : super();
}

class LoadWishListSuccess extends WishListStates {
  final WishList wishList;

  LoadWishListSuccess({this.wishList}) : super();

  @override
  List<Object> get props => [wishList];
}

class AddWishListSuccess extends WishListStates {
  AddWishListSuccess() : super();

  @override
  List<Object> get props => [];
}

class DeleteWishListItemSuccess extends WishListStates {
  final WishListItem wishListItem;
  final WishList wishList;

  DeleteWishListItemSuccess({this.wishList,this.wishListItem}) : super();

  @override
  List<Object> get props => [];
}

class LoadWishListFail extends WishListStates {
  final dynamic error;

  LoadWishListFail(this.error) : super();

  @override
  List<Object> get props => error;
}

class AuthorizationFailed extends WishListStates {
  AuthorizationFailed() : super();

  @override
  List<Object> get props => [];
}
