import 'package:tienda/model/product.dart';
import 'package:tienda/model/review-request.dart';

abstract class ReviewEvents{
  ReviewEvents();


}

class LoadReview extends ReviewEvents {
  final List<Review> reviews;

  LoadReview(this.reviews) : super();


}

class AddReview extends ReviewEvents {
  final List<Review> reviews;
  final ReviewRequest reviewRequest;

  AddReview(this.reviews,this.reviewRequest) : super();

}
