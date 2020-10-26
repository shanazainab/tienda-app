import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/live-stream-api-client.dart';
import 'package:tienda/bloc/events/live-events.dart';
import 'package:tienda/bloc/states/live-states.dart';
import 'package:tienda/model/live-video.dart';

class LiveContentsBloc extends Bloc<LiveEvents, LiveStates> {
  LiveContentsBloc() : super(Loading());

  @override
  Stream<LiveStates> mapEventToState(LiveEvents event) async* {
    if (event is LoadCurrentLiveVideoList) {
      yield* _mapLoadLiveVideoListToStates(event);
    }
    if (event is LoadAllLiveStreamList) {
      yield* _mapLoadAllLiveVideoListToStates(event);
    }
  }

  Stream<LiveStates> _mapLoadLiveVideoListToStates(
      LoadCurrentLiveVideoList event) async* {
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    List<LiveVideo> liveContents;
    LiveStreamApiClient liveStreamApiClient = LiveStreamApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await liveStreamApiClient.getOngoingLiveStreams().then((response) {
      log("GET ONGOING LIVE STREAMS RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          liveContents = List<LiveVideo>.from(
              json.decode(response)['live'].map((x) => LiveVideo.fromJson(x)));
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET ONGOING LIVE STREAMS-ERROR:", error);
      }
    });
    LiveVideo featuredLiveContent;

    if (liveContents.length == 1) {
      featuredLiveContent = liveContents[0];
    }
    for (final liveContent in liveContents) {
      if (liveContent.isFeatured) {
        featuredLiveContent = liveContent;
      }
    }

    if (liveContents != null)
      yield LoadCurrentLiveVideoListSuccess(
          featuredLiveContent: featuredLiveContent, liveVideos: liveContents);
  }

  Stream<LiveStates> _mapLoadAllLiveVideoListToStates(
      LoadAllLiveStreamList event) async* {
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    List<LiveVideo> liveVideos;
    LiveStreamApiClient liveStreamApiClient = LiveStreamApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await liveStreamApiClient.getAllLiveStreams().then((response) {
      log("GET ALL LIVE STREAMS RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          liveVideos = List<LiveVideo>.from(
              json.decode(response)['live'].map((x) => LiveVideo.fromJson(x)));
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET ALL LIVE STREAMS-ERROR:", error);
      }
    });

    ///Hack to make a single live video to be featured (if only one live current now)
    LiveVideo featuredLiveContent;
    if (liveVideos.length == 1) {
      featuredLiveContent = liveVideos[0];
    }
    int liveCount = 0;

    for (final liveContent in liveVideos) {
      if (liveContent.isLive) {
        ++liveCount;
        featuredLiveContent = liveContent;
      }
      if (liveContent.isFeatured) {
        featuredLiveContent = liveContent;
      }
    }
    if (liveCount != 1) {
      featuredLiveContent = null;
    }

    ///TODO : GROUP SCHEDULED BASED ON DATE

    Map<DateTime, List<LiveVideo>> groupedList = new HashMap();

    liveVideos.sort((a, b) {
      return a.liveTime.compareTo(b.liveTime);
    });
    for (final liveVideo in liveVideos) {
      if (groupedList.containsKey(liveVideo.liveTime)) {
        groupedList[liveVideo.liveTime].add(liveVideo);
      } else {
        groupedList[liveVideo.liveTime] = new List()..add(liveVideo);
      }
    }
    if (liveVideos != null)
      yield LoadAllLiveVideoListSuccess(
          featuredLiveContent: featuredLiveContent, liveVideos: liveVideos,groupedLiveContent: groupedList);
  }
}
