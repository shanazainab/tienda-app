// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map<String, dynamic> json) {
  return Cart(
      cartPrice: json['cart-price'] == null
          ? null
          : CartPrice.fromJson(json['cart-price'] as Map<String, dynamic>),
      cartItems: (json['cart-items'] as List)
          ?.map((e) =>
              e == null ? null : CartItem.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
      'cart-items': instance.cartItems,
      'cart-price': instance.cartPrice,
    };

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return CartItem(
    product: json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>),
    quantity: json['quantity'] as int,
    color: json['color'] as String,
    size: json['size'] as String,
  );
}

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'product': instance.product,
      'quantity': instance.quantity,
      'color': instance.color,
      'size': instance.size,
    };

CartPrice _$CartPriceFromJson(Map<String, dynamic> json) {
  return CartPrice(
    deliverCharge: (json['deliver-charge'] as num)?.toDouble(),
    cartTotal: (json['cart-total'] as num)?.toDouble(),
    discountTotal: (json['discount-total'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$CartPriceToJson(CartPrice instance) => <String, dynamic>{
      'cart-total': instance.cartTotal,
      'discount-total': instance.discountTotal,
      'deliver-charge': instance.deliverCharge,
    };
