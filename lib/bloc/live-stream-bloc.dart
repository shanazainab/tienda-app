import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/live-stream-api-client.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/states/live-stream-states.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/live-response.dart';

class LiveStreamBloc extends Bloc<LiveStreamEvents, LiveStreamStates> {
  @override
  LiveStreamStates get initialState => Loading();

  @override
  Stream<LiveStreamStates> mapEventToState(LiveStreamEvents event) async* {
    if (event is JoinLive) {
      yield* _mapFetchJoinLiveToStates(event);
    }
  }

  Stream<LiveStreamStates> _mapFetchJoinLiveToStates(JoinLive event) async* {
    final dio = Dio();

    LiveResponse liveResponse;
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    LiveStreamApiClient liveStreamApiClient = LiveStreamApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await liveStreamApiClient.joinTheLive(event.presenterId).then((response) {
      log("JOIN-LIVE-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          liveResponse = liveResponseFromJson(response);
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("JOIN-LIVE-ERROR:", error);
      }
    });

    if(liveResponse != null)
      yield JoinLiveSuccess(liveResponse);

  }
}
