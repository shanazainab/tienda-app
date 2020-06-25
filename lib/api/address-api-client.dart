import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/customer.dart';
part 'address-api-client.g.dart';

@RestApi()
abstract class AddressApiClient {
  factory AddressApiClient(Dio dio, {String baseUrl}) = _AddressApiClient;

  @POST("")
  Future<String> addSavedAddress(@Body() Customer customer);

  @GET("")
  Future<String> getSavedAddress();
  @POST("")
  Future<String> editSavedAddress();
  @POST("")
  Future<String> deleteSavedAddress();
}
