// To parse this JSON data, do
//
//     final suggestionResponse = suggestionResponseFromJson(jsonString);

import 'dart:convert';

SuggestionResponse suggestionResponseFromJson(String str) => SuggestionResponse.fromJson(json.decode(str));

String suggestionResponseToJson(SuggestionResponse data) => json.encode(data.toJson());

class SuggestionResponse {
  SuggestionResponse({
    this.status,
    this.suggestions,
  });

  int status;
  List<Suggestion> suggestions;

  factory SuggestionResponse.fromJson(Map<String, dynamic> json) => SuggestionResponse(
    status: json["status"],
    suggestions: List<Suggestion>.from(json["suggestions"].map((x) => Suggestion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "suggestions": List<dynamic>.from(suggestions.map((x) => x.toJson())),
  };
}

class Suggestion {
  Suggestion({
    this.suggestion,
    this.categoryEn,
    this.categoryAr,
  });

  String suggestion;
  String categoryEn;
  String categoryAr;

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
    suggestion: json["suggestion"],
    categoryEn: json["category_en"],
    categoryAr: json["category_ar"],
  );

  Map<String, dynamic> toJson() => {
    "suggestion": suggestion,
    "category_en": categoryEn,
    "category_ar": categoryAr,
  };
}
