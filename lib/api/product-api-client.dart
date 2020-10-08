import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'product-api-client.g.dart';

@RestApi()
abstract class ProductApiClient {
  factory ProductApiClient(Dio dio, {String baseUrl}) = _ProductApiClient;

  @GET("/get_products_by_category/{categoryId}")
  Future<String> getProductsByCategory(@Path("categoryId") String categoryId, @Query("page") String pageNumber);


  @GET("/get_product_details/{productId}")
  Future<String> getProductDetailsByCategory(@Path("productId") String productId);


}
