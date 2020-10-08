import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'presenter-api-client.g.dart';

@RestApi()
abstract class PresenterApiClient {
  factory PresenterApiClient(Dio dio, {String baseUrl}) =
  _PresenterApiClient;

  @GET("/get_presenters/")
  Future<String> getPresenterList();

  @GET("/get_presenter_details/{presenterId}")
  Future<String> getPresenterDetails(@Path('presenterId') String presenterId);



  @GET("/change_following_status/{presenterId}")
  Future<String> changeFollowingStatus(@Path('presenterId') String presenterId);


  @GET("/get_live_presenters/")
  Future<String> getLivePresenters();

  @GET("/get_featured_presenters/")
  Future<String> getPopularPresenters();
}
