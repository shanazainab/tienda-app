// To parse this JSON data, do
//
//     final livePresenterResponse = livePresenterResponseFromJson(jsonString);

import 'dart:convert';

import 'package:tienda/model/presenter.dart';

LivePresenterResponse livePresenterResponseFromJson(String str) => LivePresenterResponse.fromJson(json.decode(str));

String livePresenterResponseToJson(LivePresenterResponse data) => json.encode(data.toJson());

class LivePresenterResponse {
  LivePresenterResponse({
    this.status,
    this.presenters,
    this.membership,
  });

  int status;
  List<Presenter> presenters;
  String membership;

  factory LivePresenterResponse.fromJson(Map<String, dynamic> json) => LivePresenterResponse(
    status: json["status"],
    presenters: List<Presenter>.from(json["presenters"].map((x) => Presenter.fromJson(x))),
    membership: json["membership"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "presenters": List<dynamic>.from(presenters.map((x) => x.toJson())),
    "membership": membership,
  };
}


