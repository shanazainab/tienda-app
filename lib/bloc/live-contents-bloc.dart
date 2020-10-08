import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/home-api-client.dart';
import 'package:tienda/bloc/events/live-events.dart';
import 'package:tienda/bloc/states/live-states.dart';
import 'package:tienda/model/live-contents.dart';

class LiveContentsBloc extends Bloc<LiveEvents, LiveStates> {
  LiveContentsBloc() : super(Loading());

  @override
  Stream<LiveStates> mapEventToState(LiveEvents event) async* {
    if (event is LoadLiveVideoList) {
      yield* _mapLoadLiveVideoListToStates(event);
    }
  }

  Stream<LiveStates> _mapLoadLiveVideoListToStates(
      LoadLiveVideoList event) async* {
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    List<LiveContent> liveContents;
    HomeApiClient homeApiClient =
        HomeApiClient(dio, baseUrl: GlobalConfiguration().getString("devURL"));
    await homeApiClient.getLiveContents().then((response) {
      log("LIVE DATA RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          liveContents = List<LiveContent>.from(json
              .decode(response)['live']
              .map((x) => LiveContent.fromJson(x)));
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("LIVE-DATA-ERROR:", error);
      }
    });
    LiveContent featuredLiveContent;
    for (final liveContent in liveContents) {
      if (liveContent.isFeatured) {
        featuredLiveContent = liveContent;
      }
    }
    if (liveContents != null)
      yield LoadLiveVideoListSuccess(
          featuredLiveContent: featuredLiveContent, liveContents: liveContents);
  }
}
