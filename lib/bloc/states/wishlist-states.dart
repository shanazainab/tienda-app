import 'package:tienda/model/wishlist.dart';

abstract class WishListStates {
  WishListStates();
}

class Loading extends WishListStates {
  Loading() : super();
}

class LoadWishListSuccess extends WishListStates {
  final WishList wishList;

  LoadWishListSuccess({this.wishList}) : super();
}

class AddWishListSuccess extends WishListStates {
  AddWishListSuccess() : super();
}

class DeleteWishListItemSuccess extends WishListStates {
  final WishListItem wishListItem;
  final WishList wishList;

  DeleteWishListItemSuccess({this.wishList, this.wishListItem}) : super();
}

class LoadWishListFail extends WishListStates {
  final dynamic error;

  LoadWishListFail(this.error) : super();
}

class EmptyWishList extends WishListStates {
  EmptyWishList() : super();
}

class AuthorizationFailed extends WishListStates {
  AuthorizationFailed() : super();
}
