import 'package:equatable/equatable.dart';
import 'package:tienda/model/product.dart';

class WishList extends Equatable {
  List<WishListItem> wishListItems;

  WishList({this.wishListItems});

  factory WishList.fromJson(Map<String, dynamic> json) {
    return WishList(
        wishListItems: (json['wish-list-item'] as List)
            ?.map((e) => e == null
                ? null
                : WishListItem.fromJson(e as Map<String, dynamic>))
            ?.toList());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wish-list-item'] = this.wishListItems;

    return data;
  }

  @override
  // TODO: implement props
  List<Object> get props => [wishListItems];
}

class WishListItem extends Equatable {
  Product product;
  String color;
  String size;

  WishListItem({this.product, this.color, this.size});

  factory WishListItem.fromJson(Map<String, dynamic> json) {
    return WishListItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      color: json['color'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product'] = this.product;
    data['color'] = this.color;
    data['size'] = this.size;

    return data;
  }

  @override
  // TODO: implement props
  List<Object> get props => [product.id];
}
