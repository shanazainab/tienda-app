import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/api/orders-api-client.dart';
import 'package:tienda/api/review-api-client.dart';
import 'package:tienda/bloc/events/review-events.dart';
import 'package:dio/dio.dart';
import 'package:tienda/bloc/states/review-states.dart';
import 'package:tienda/model/product.dart';

class ReviewBloc extends Bloc<ReviewEvents, ReviewStates> {
  @override
  ReviewStates get initialState => Loading();

  @override
  Stream<ReviewStates> mapEventToState(ReviewEvents event) async* {
    if (event is LoadReview) {
      yield* _mapLoadReviewToStates(event);
    }
    if (event is AddReview) {
      yield* _mapAddToReviewToStates(event);
    }
  }

  Stream<ReviewStates> _mapLoadReviewToStates(LoadReview event) async* {
    yield LoadReviewSuccess(event.reviews);
  }

  Stream<ReviewStates> _mapAddToReviewToStates(AddReview event) async* {
    if (event.reviewRequest.images != null &&
        event.reviewRequest.images.isNotEmpty) {
      event.reviewRequest.isPhotos = true;
      event.reviewRequest.photos = new List();
    }
    else
      event.reviewRequest.isPhotos = false;

    ///convert file image to base64
    for (final image in event.reviewRequest.images) {
      if (image != null) {
        List<int> imageBytes = image.readAsBytesSync();
        print(imageBytes);
        String encodedImage = base64Encode(imageBytes);
        String mimeType = mime(image.path);
        String formattedCode = 'data:$mimeType;base64,$encodedImage';

        event.reviewRequest.photos.add(formattedCode);
      }
    }

    /// data:image/jpeg;base64,

    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;

    String status;
    ReviewApiClient reviewApiClient = ReviewApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await reviewApiClient.addReview(event.reviewRequest).then((response) {
      Logger().d("ADD-REVIEW-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("ADD-REVIEWS-ERROR:", error);
      }
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Review review = new Review(
        body: event.reviewRequest.body,
        customerName: sharedPreferences.getString("customer-name"),
        rating: event.reviewRequest.rating,
        fileImages: event.reviewRequest.images,
        elapsedTime: "a sec ago");
    event.reviews..add(review);


    print(event.reviews);
    if (status == "success") yield AddReviewSuccess(event.reviews);
  }
}
