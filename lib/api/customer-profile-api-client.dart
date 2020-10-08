import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:retrofit/http.dart';
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

  @POST("/update_profile/")
  Future<String> editCustomerDetails(@Body() Customer customer);

  @POST("/change_profile_picture/")
  Future<String> updateProfilePicture(@Body() String encodedImage);

  @POST("/change_phone_number/")
  Future<String> changePhoneNumber(@Body() String phoneNumber);

  @POST("/verify_update_phone_number/")
  Future<String> verifyUpdatedPhoneNumber(
      @Body() String phoneNumber, @Body() String otp);

  @GET("/get_watch_history/")
  Future<String> getWatchHistory();

}
