import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
part 'wishlist-api-client.g.dart';

@RestApi()
abstract class WishListApiClient {
  factory WishListApiClient(Dio dio, {String baseUrl}) = _WishListApiClient;

  @POST("/add_to_wishlist/")
  Future<String> addToWishList(@Body() int productId);

  @GET("/get_wishlist/")
  Future<String> fetchWishList();

  @POST("/delete_from_wishlist/")
  Future<String> deleteFromWishList(@Body() int productId);
}
