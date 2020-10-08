import 'package:tienda/model/wishlist.dart';

abstract class WishListEvents  {
  WishListEvents();


}

class LoadWishListProducts extends WishListEvents {
  final WishList wishList;

  LoadWishListProducts({this.wishList}) : super();


}

class OfflineLoadWishList extends WishListEvents {
  OfflineLoadWishList() : super();


}

class AddToWishList extends WishListEvents {
  final WishListItem wishListItem;

  AddToWishList({this.wishListItem}) : super();


}

class DeleteWishListItem extends WishListEvents {
  final WishList wishList;
  final WishListItem wishListItem;

  DeleteWishListItem({this.wishList, this.wishListItem}) : super();


}
