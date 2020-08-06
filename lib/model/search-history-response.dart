// To parse this JSON data, do
//
//     final searchHistoryResponse = searchHistoryResponseFromJson(jsonString);

import 'dart:convert';

SearchHistoryResponse searchHistoryResponseFromJson(String str) => SearchHistoryResponse.fromJson(json.decode(str));

String searchHistoryResponseToJson(SearchHistoryResponse data) => json.encode(data.toJson());

class SearchHistoryResponse {
  SearchHistoryResponse({
    this.status,
    this.history,
  });

  int status;
  List<History> history;

  factory SearchHistoryResponse.fromJson(Map<String, dynamic> json) => SearchHistoryResponse(
    status: json["status"],
    history: List<History>.from(json["history"].map((x) => History.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "history": List<dynamic>.from(history.map((x) => x.toJson())),
  };
}

class History {
  History({
    this.query,
  });

  String query;

  factory History.fromJson(Map<String, dynamic> json) => History(
    query: json["query"],
  );

  Map<String, dynamic> toJson() => {
    "query": query,
  };
}
