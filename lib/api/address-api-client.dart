import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:retrofit/http.dart';
import 'package:tienda/model/delivery-address.dart';

part 'address-api-client.g.dart';

@RestApi()
abstract class AddressApiClient {
  factory AddressApiClient(Dio dio, {String baseUrl}) = _AddressApiClient;

  @POST("/add_address/")
  Future<String> addSavedAddress(@Body() DeliveryAddress address);

  @GET("/get_addresses/")
  Future<String> getSavedAddress();
  @POST("/edit_address/")
  Future<String> editSavedAddress(@Body() DeliveryAddress address);
  @POST("/delete_address/")
  Future<String> deleteSavedAddress(@Body() int addressId);
}
