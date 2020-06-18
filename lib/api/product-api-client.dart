import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/customer.dart';
part 'product-api-client.g.dart';

@RestApi()
abstract class ProductApiClient {
  factory ProductApiClient(Dio dio, {String baseUrl}) = _ProductApiClient;

  @GET("/get_dummy_products/")
  Future<String> getDummyProducts();
}
