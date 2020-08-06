import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';

part 'faq-api-client.g.dart';

@RestApi()
abstract class FAQApiClient {
  factory FAQApiClient(Dio dio, {String baseUrl}) = _FAQApiClient;

  @GET("/get_referral_faqs/")
  Future<String> getReferralFAQ();

  @GET("/get_general_faqs/")
  Future<String> getGeneralFAQ();
}
