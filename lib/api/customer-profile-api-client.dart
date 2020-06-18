import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/customer.dart';
part 'customer-profile-api-client.g.dart';

@RestApi()
abstract class CustomerProfileApiClient {
  factory CustomerProfileApiClient(Dio dio, {String baseUrl}) =
      _CustomerProfileApiClient;

  @POST("/phone_register/")
  Future<String> registerCustomerDetails(@Body() Customer customer);

  @GET("/get_profile/")
  Future<String> getCustomerProfile();

}
