import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'orders-api-client.g.dart';

@RestApi()
abstract class OrdersApiClient {
  factory OrdersApiClient(Dio dio, {String baseUrl}) =
  _OrdersApiClient;

  @GET("/get_orders/")
  Future<String> getOrders();


  @POST("/cancel_order/")
  Future<String> cancelOrder(@Body() int orderId);

  @POST("/request_return//")
  Future<String> returnOrder(@Body() int orderId);
}
