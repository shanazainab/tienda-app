// To parse this JSON data, do
//
//     final presenterReview = presenterReviewFromJson(jsonString);

import 'dart:convert';

PresenterReview presenterReviewFromJson(String str) => PresenterReview.fromJson(json.decode(str));

String presenterReviewToJson(PresenterReview data) => json.encode(data.toJson());

class PresenterReview {
  PresenterReview({
    this.questions,
    this.feedback,
  });

  List<Question> questions;
  String feedback;

  factory PresenterReview.fromJson(Map<String, dynamic> json) => PresenterReview(
    questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
    feedback: json["feedback"],
  );

  Map<String, dynamic> toJson() => {
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
    "feedback": feedback,
  };
}

class Question {
  Question({
    this.question,
    this.rating,
  });

  String question;
  int rating;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    question: json["question"],
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "rating": rating,
  };
}
