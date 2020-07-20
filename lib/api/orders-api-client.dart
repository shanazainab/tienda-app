import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
part 'orders-api-client.g.dart';

@RestApi()
abstract class OrdersApiClient {
  factory OrdersApiClient(Dio dio, {String baseUrl}) =
  _OrdersApiClient;

  @GET("/get_orders/")
  Future<String> getOrders();

}
