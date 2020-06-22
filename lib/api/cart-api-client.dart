import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
part 'cart-api-client.g.dart';

@RestApi()
abstract class CartApiClient {
  factory CartApiClient(Dio dio, {String baseUrl}) =
      _CartApiClient;

  @POST("/add_to_cart/")
  Future<String> addToCart(@Body() int productId);

  @POST("/delete_from_cart/")
  Future<String> deleteFromCart(@Body() int productId);
}
