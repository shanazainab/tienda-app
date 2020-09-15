import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/payment-card.dart';
part 'payment-api-client.g.dart';

@RestApi()
abstract class PaymentApiClient {
  factory PaymentApiClient(Dio dio, {String baseUrl}) = _PaymentApiClient;

  @GET("/check_card_details/")
  Future<String> checkCartDetails(@Body() PaymentCard paymentCard);

  @POST("/delete_card/")
  Future<String> deleteSavedCard(@Body() int cardId);

  @GET("/get_saved_cards/")
  Future<String> getSavedCards();
}
