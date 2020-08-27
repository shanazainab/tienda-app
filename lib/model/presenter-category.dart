// To parse this JSON data, do
//
//     final presenterCategory = presenterCategoryFromJson(jsonString);

import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:tienda/model/presenter.dart';

PresenterCategory presenterCategoryFromJson(String str) =>
    PresenterCategory.fromJson(json.decode(str));

String presenterCategoryToJson(PresenterCategory data) =>
    json.encode(data.toJson());

class PresenterCategory {
  PresenterCategory({
    this.status,
    this.response,
    this.membership,
  });

  /// "membership": "premium"
  int status;
  List<Response> response;
  String membership;

  factory PresenterCategory.fromJson(Map<String, dynamic> json) =>
      PresenterCategory(
          status: json["status"],
          response: List<Response>.from(
              json["response"].map((x) => Response.fromJson(x))),
          membership: json['membership']);

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
        "membership": membership
      };

  @override
  String toString() {
    return 'PresenterCategory{status: $status, response: $response, membership: $membership}';
  }
}

class Response {
  Response({
    this.nameEn,
    this.nameAr,
    this.categoryId,
    this.presenters,
  });

  String nameEn;
  String nameAr;
  int categoryId;
  List<Presenter> presenters;

  factory Response.fromJson(Map<String, dynamic> json) {
    Response response;
    try {
      response = Response(
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
        categoryId: json["category_id"],
        presenters: List<Presenter>.from(
            json["presenters"].map((x) => Presenter.fromJson(x))),
      );
    } catch (err) {
      Logger().e(err);
    }

    return response;
  }

  Map<String, dynamic> toJson() => {
        "name_en": nameEn,
        "name_ar": nameAr,
        "category_id": categoryId,
        "presenters": List<dynamic>.from(presenters.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'Response{nameEn: $nameEn, nameAr: $nameAr, categoryId: $categoryId, presenters: $presenters}';
  }
}
