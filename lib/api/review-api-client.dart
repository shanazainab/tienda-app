import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:retrofit/http.dart';
import 'package:tienda/model/review-request.dart';

part 'review-api-client.g.dart';

@RestApi()
abstract class ReviewApiClient {
  factory ReviewApiClient(Dio dio, {String baseUrl}) = _ReviewApiClient;

  @POST("/add_review/")
  Future<String> addReview(
      @Body() ReviewRequest reviewRequest);
}
