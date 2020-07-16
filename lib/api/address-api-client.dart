import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/delivery-address.dart';
part 'address-api-client.g.dart';

@RestApi()
abstract class AddressApiClient {
  factory AddressApiClient(Dio dio, {String baseUrl}) = _AddressApiClient;

  @POST("/add_address/")
  Future<String> addSavedAddress(@Body() DeliveryAddress address);

  @GET("")
  Future<String> getSavedAddress();
  @POST("")
  Future<String> editSavedAddress();
  @POST("")
  Future<String> deleteSavedAddress();
}
