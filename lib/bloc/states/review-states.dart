
import 'package:tienda/model/product.dart';

abstract class ReviewStates {
  ReviewStates();
}

class Loading extends ReviewStates {
  Loading() : super();
}

class LoadReviewSuccess extends ReviewStates {
  final List<Review> reviews;

  LoadReviewSuccess(this.reviews) : super();
}

class AddReviewSuccess extends ReviewStates {
  final List<Review> newReviews;

  AddReviewSuccess(this.newReviews) : super();
}
