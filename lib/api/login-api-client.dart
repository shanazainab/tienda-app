import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:tienda/model/login-request.dart';
import 'package:tienda/model/login-verify-request.dart';

part 'login-api-client.g.dart';

@RestApi()
abstract class LoginApiClient {
  factory LoginApiClient(Dio dio, {String baseUrl}) = _LoginApiClient;

  @POST("/phone_login/")
  Future<String> sendOTP(@Body() LoginRequest loginRequest);

  @POST("/verify_phone/")
  Future<Map<String, dynamic>> verifyOTP(
      @Body() LoginVerifyRequest loginVerifyRequest);

  @POST("/check_google_token/")
   Future<Map<String, dynamic>> checkGoogleToken(@Body() String accessToken);

  @POST("/check_facebook_token/")
   Future<Map<String, dynamic>> checkFacebookToken(@Body() String accessToken);

  @POST("/get_cookie/")
  Future<Map<String, dynamic>> getGuestLoginSessionId(@Body() String deviceId);

   @GET("/check_cookie/")
  Future<String> checkCookie();

  @GET("/customer_logout/")
  Future<String> logout();

  @POST("/update_device_id/")
  Future<String> updateDeviceId(@Body() String deviceId);


}
