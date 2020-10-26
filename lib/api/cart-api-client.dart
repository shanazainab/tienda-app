import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:retrofit/http.dart';
import 'package:tienda/model/payment-card.dart';

part 'cart-api-client.g.dart';

@RestApi()
abstract class CartApiClient {
  factory CartApiClient(Dio dio, {String baseUrl}) = _CartApiClient;

  @GET("/get_cart/")
  Future<String> getCart();

  @POST("/add_to_cart/")
  Future<String> addToCart(@Body() int productId, @Body() int quantity);

  @POST("/delete_from_cart/")
  Future<String> deleteFromCart(@Body() int productId);

  @POST("/checkout/")
  Future<String> cartCheckout(@Body() int addressId,@Body() PaymentCard paymentCard,@Body() int cardId,@Body() int cvv);

  @POST("/change_cart_product_quantity/")
  Future<String> changeQuantity(@Body() int productId, @Body() int quantity);

  @POST("/redeem_coupon/")
  Future<String> applyCoupon(@Body() String coupon);

  @POST("/remove_coupon/")
  Future<String> removeAppliedCoupon(@Body() String couponCode);
}
