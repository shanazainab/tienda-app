import 'package:tienda/model/live-response.dart';
import 'package:tienda/model/presenter-review-response.dart';
import 'package:tienda/model/product.dart';

abstract class LiveStreamStates {
  LiveStreamStates();
}

class Loading extends LiveStreamStates {}

class InitializationSuccess extends LiveStreamStates {}

class JoinLiveSuccess extends LiveStreamStates {
  final LiveResponse liveResponse;

  JoinLiveSuccess(this.liveResponse) : super();
}

class UpdateWishListProductsSuccess extends LiveStreamStates {
  final List<Product> products;

  UpdateWishListProductsSuccess(
    this.products,
  ) : super();
}

class NotAuthorized extends LiveStreamStates {
  NotAuthorized() : super();
}

class MessageReceived extends LiveStreamStates {
  final String body;
  final String senderName;
  final String profileImage;
  final int timestamp;

  MessageReceived(this.body, this.profileImage, this.timestamp, this.senderName)
      : super();
}

class ShowProductSuccess extends LiveStreamStates {
  final Product product;

  ShowProductSuccess(this.product) : super();
}

class GetReviewsSuccess extends LiveStreamStates {
  final PresenterReviewResponse presenterReviewResponse;

  GetReviewsSuccess(this.presenterReviewResponse) : super();
}

class SubmitReviewSuccess extends LiveStreamStates {
  SubmitReviewSuccess() : super();
}

class GetReviewsNotAllowed extends LiveStreamStates {
  GetReviewsNotAllowed() : super();
}
