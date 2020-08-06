import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/faq-api-client.dart';
import 'package:tienda/bloc/events/faq-events.dart';
import 'package:tienda/bloc/states/faq-states.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/faq.dart';

class FAQBloc extends Bloc<FAQEvents, FAQStates> {
  @override
  FAQStates get initialState => Loading();

  @override
  Stream<FAQStates> mapEventToState(FAQEvents event) async* {
    if (event is LoadReferralQuestions) {
      yield* _mapLoadReferralQuestionToStates(event);
    }
    if (event is LoadGeneralQuestions) {
      yield* _mapLoadGeneralQuestionToStates(event);
    }
  }

  Stream<FAQStates> _mapLoadGeneralQuestionToStates(
      LoadGeneralQuestions event) async* {
    final dio = Dio();
    List<Faq> faqs;
    final client =
        FAQApiClient(dio, baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.getGeneralFAQ().then((response) {
      Logger().d("FAQ GENERAL RESPONSE:$response");

      if (json.decode(response)['status'] == 200) {
        FAQResponse faqResponse = responseFromJson(response);
        faqs = faqResponse.faqs;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("CATEGORY LIST-ERROR:", error);
      }
    });
    yield LoadGeneralQuestionsSuccess(faqs);
  }

  Stream<FAQStates> _mapLoadReferralQuestionToStates(
      LoadReferralQuestions event) async* {
    final dio = Dio();
    List<Faq> faqs;
    final client =
        FAQApiClient(dio, baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.getReferralFAQ().then((response) {
      Logger().d("FAQ REFERRAL RESPONSE:$response");

      if (json.decode(response)['status'] == 200) {
        FAQResponse faqResponse = responseFromJson(response);
        faqs = faqResponse.faqs;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("CATEGORY LIST-ERROR:", error);
      }
    });

    yield LoadGeneralQuestionsSuccess(faqs);
  }
}

FAQResponse responseFromJson(String str) =>
    FAQResponse.fromJson(json.decode(str));

String responseToJson(FAQResponse data) => json.encode(data.toJson());

class FAQResponse {
  FAQResponse({
    this.status,
    this.faqs,
  });

  int status;
  List<Faq> faqs;

  factory FAQResponse.fromJson(Map<String, dynamic> json) => FAQResponse(
        status: json["status"],
        faqs: List<Faq>.from(json["faqs"].map((x) => Faq.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "faqs": List<dynamic>.from(faqs.map((x) => x.toJson())),
      };
}
