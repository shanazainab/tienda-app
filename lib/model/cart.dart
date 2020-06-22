import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tienda/model/product.dart';
part 'cart.g.dart';

@JsonSerializable()
class Cart {
  @JsonKey(name: "cart-items")
  List<CartItem> cartItems;

  @JsonKey(name: "cart-price")
  CartPrice cartPrice;

  Cart({this.cartItems, this.cartPrice});

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Map<String, dynamic> toJson() => _$CartToJson(this);
}

@JsonSerializable()
class CartItem extends Equatable{
  Product product;
  int quantity;
  String color;
  String size;

  CartItem({this.product, this.quantity, this.color, this.size});

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  @override
  List<Object> get props => [product.id];
}

@JsonSerializable()
class CartPrice {
  @JsonKey(name: "cart-total")
  double cartTotal;
  @JsonKey(name: "discount-total")
  double discountTotal;
  @JsonKey(name: "deliver-charge")
  double deliverCharge;


  CartPrice({this.cartTotal, this.discountTotal, this.deliverCharge});

  factory CartPrice.fromJson(Map<String, dynamic> json) =>
      _$CartPriceFromJson(json);

  Map<String, dynamic> toJson() => _$CartPriceToJson(this);

  @override
  String toString() {
    return 'CartPrice{cartTotal: $cartTotal, discountTotal: $discountTotal, deliverCharge: $deliverCharge}';
  }
}
