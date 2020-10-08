// To parse this JSON data, do
//
//     final presenterReviewResponse = presenterReviewResponseFromJson(jsonString);

import 'dart:convert';

import 'package:logger/logger.dart';

PresenterReviewResponse presenterReviewResponseFromJson(String str) =>
    PresenterReviewResponse.fromJson(json.decode(str));

String presenterReviewResponseToJson(PresenterReviewResponse data) =>
    json.encode(data.toJson());

class PresenterReviewResponse {
  PresenterReviewResponse({
    this.status,
    this.info,
    this.questions,
  });

  int status;
  String info;
  List<String> questions;

  @override
  String toString() {
    return 'PresenterReviewResponse{status: $status, info: $info, questions: $questions}';
  }

  factory PresenterReviewResponse.fromJson(Map<String, dynamic> json) {
    PresenterReviewResponse presenterReviewResponse;

    try {
      presenterReviewResponse = PresenterReviewResponse(
        status: json["status"],
        info: json["info"],
        questions: List<String>.from(json["questions"].map((x) => x)),
      );
    } catch (e) {
      Logger().e(presenterReviewResponse);
    }
    return presenterReviewResponse;
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "info": info,
        "questions": List<dynamic>.from(questions.map((x) => x)),
      };
}
