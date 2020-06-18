import 'package:json_annotation/json_annotation.dart';
import 'package:tienda/model/product.dart';
part 'cart.g.dart';

@JsonSerializable()
class Cart {
  @JsonKey(name: "cart-items")
  List<CartItem> cartItems;

  @JsonKey(name: "cart-price")
  CartPrice cartPrice;

  Cart(this.cartItems, this.cartPrice);

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Map<String, dynamic> toJson() => _$CartToJson(this);
}

@JsonSerializable()
class CartItem {
  Product product;
  int quantity;
  String color;
  String size;

  CartItem(this.product, this.quantity, this.color, this.size);

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}

@JsonSerializable()
class CartPrice {
  @JsonKey(name: "cart-total")
  double cartTotal;
  double discount;
  @JsonKey(name: "order-total")
  double orderTotal;
  @JsonKey(name: "deliver-charge")
  double deliverCharge;
  @JsonKey(name: "checkout-total")
  double checkoutTotal;

  CartPrice(this.cartTotal, this.discount, this.orderTotal, this.deliverCharge,
      this.checkoutTotal);

  factory CartPrice.fromJson(Map<String, dynamic> json) =>
      _$CartPriceFromJson(json);

  Map<String, dynamic> toJson() => _$CartPriceToJson(this);
}
