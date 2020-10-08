import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/live-stream-review-bloc.dart';
import 'package:tienda/model/presenter-review-response.dart';
import 'package:tienda/model/presenter-review.dart';
import 'package:tienda/model/presenter.dart';

class LiveStreamReviewContainer extends StatelessWidget {
  final Presenter presenter;
  final PresenterReviewResponse presenterReviewResponse;

  final LiveStreamReviewBloc liveStreamReviewBloc;

  LiveStreamReviewContainer(
      this.presenter, this.presenterReviewResponse, this.liveStreamReviewBloc);

  final PresenterReview presenterReview = new PresenterReview(questions: []);

  final TextEditingController feedbackTextController =
      new TextEditingController();
  final dataKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Start your review ",
                  style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.30000001192092896,
                  )),
              SizedBox(
                height: 8,
              ),
              ListView.builder(
                  itemCount: presenterReviewResponse.questions.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.only(bottom: 17.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(presenterReviewResponse.questions[index],
                                style: TextStyle(
                                  color: Color(0xff555555),
                                  fontSize: 13,
                                )),
                            RatingBar(
                              initialRating: 0,
                              minRating: 1,
                              itemSize: 20,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 0.5),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Color(0xFFf9d572),
                                size: 14,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);

                                if (presenterReview.questions.isNotEmpty) {
                                  presenterReview.questions.removeWhere(
                                      (element) =>
                                          element.question ==
                                          presenterReviewResponse
                                              .questions[index]);
                                }
                                presenterReview.questions.add(new Question(
                                    question: presenterReviewResponse
                                        .questions[index],
                                    rating: rating.round()));
                              },
                            ),
                          ],
                        ),
                      )),
              SizedBox(
                height: 14,
              ),
              Text("Your feedback",
                  style: TextStyle(
                    color: Color(0xff555555),
                    fontSize: 13,
                  )),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                key: dataKey,
                minLines: 3,
                maxLines: 4,
                controller: feedbackTextController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(
                    color: Color(0xff555555),
                    fontSize: 13,
                  ),
                  hintText: 'Anything you want to say?',
                  labelStyle: TextStyle(fontSize: 12),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  presenterReview.feedback = feedbackTextController.text;
                  if(presenterReview.feedback == null)
                    presenterReview.feedback = "";
                  liveStreamReviewBloc
                      .add(SubmitReview(presenter.id, presenterReview));
                },
                child: Text("Submit"),
              )
            ]),
      ),
    );
  }
}
