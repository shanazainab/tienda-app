import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:tienda/model/presenter-review.dart';

part 'live-stream-api-client.g.dart';

@RestApi()
abstract class LiveStreamApiClient {
  factory LiveStreamApiClient(Dio dio, {String baseUrl}) = _LiveStreamApiClient;

  @POST("/get_presenter_review_box/{presenterId}")
  Future<String> getReviews(@Path("presenterId") int presenterId);


  @POST("/join_presenter_live/")
  Future<String> joinTheLive(@Body() int presenterId);


  @POST("/review_presenter/{presenterId}")
  Future<String> reviewPresenter(@Path("presenterId") int presenterId,@Body() PresenterReview presenterReview);

  @GET("/get_live_streams/")
  Future<String> getOngoingLiveStreams();

  @GET("/get_all_streams/")
  Future<String> getAllLiveStreams();

}
