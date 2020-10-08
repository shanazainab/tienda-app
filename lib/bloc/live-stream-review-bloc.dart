import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/live-stream-api-client.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/states/live-stream-states.dart';
import 'package:tienda/model/presenter-review-response.dart';

class LiveStreamReviewBloc extends Bloc<LiveStreamEvents, LiveStreamStates> {
  LiveStreamReviewBloc() : super(Loading());

  @override
  Stream<LiveStreamStates> mapEventToState(LiveStreamEvents event) async* {
    if (event is GetReviews) {
      yield* _mapGetReviewsToStates(event);
    }
    if (event is SubmitReview) {
      yield* _mapSubmitReviewToStates(event);
    }
  }

  Stream<LiveStreamStates> _mapGetReviewsToStates(GetReviews event) async* {
    final dio = Dio();

    PresenterReviewResponse presenterReviewResponse;

    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    LiveStreamApiClient liveStreamApiClient = LiveStreamApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await liveStreamApiClient.getReviews(event.presenterId).then((response) {
      log("GET-REVIEWS-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          presenterReviewResponse =
              presenterReviewResponseFromJson(response);
          break;
        case 201:
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET-REVIEWS-ERROR:", error);
      }
    });

    print("RESPONSE:$presenterReviewResponse");

    if(presenterReviewResponse != null)
    yield GetReviewsSuccess(presenterReviewResponse);
    else
      yield GetReviewsNotAllowed();

  }

  Stream<LiveStreamStates> _mapSubmitReviewToStates(SubmitReview event) async* {
    final dio = Dio();

    bool isLogged = true;
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    LiveStreamApiClient liveStreamApiClient = LiveStreamApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await liveStreamApiClient
        .reviewPresenter(event.presenterId, event.presenterReview)
        .then((response) {
      log("SUBMIT-REVIEW-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          break;
        case 401:
          isLogged = false;
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("SUBMIT-REVIEW-ERROR:", error);
      }
    });

    yield SubmitReviewSuccess();
  }
}
