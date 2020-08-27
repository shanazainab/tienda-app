import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/presenter-api-client.dart';
import 'package:tienda/bloc/events/follow-events.dart';
import 'package:dio/dio.dart';
import 'package:tienda/bloc/states/follow-states.dart';

class FollowBloc extends Bloc<FollowEvents, FollowStates> {
  FollowBloc() : super(Loading());



  @override
  Stream<FollowStates> mapEventToState(FollowEvents event) async* {
    if (event is ChangeFollowStatus) {
      yield* _mapChangeFollowToStates(event);
    }
  }

  Stream<FollowStates> _mapChangeFollowToStates(
      ChangeFollowStatus event) async* {


    ///CHANGE-FOLLOW-STATUS-RESPONSE:{"status": 200, "info": "unfollowed successfully"}
    ///CHANGE-FOLLOW-STATUS-RESPONSE:{"status": 200, "info": "followed successfully"}
    final dio = Dio();
    bool isFollowing = false;
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    PresenterApiClient presenterApiClient = PresenterApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await presenterApiClient
        .changeFollowingStatus(event.presenterId.toString())
        .then((response) {
      Logger().d("CHANGE-FOLLOW-STATUS-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          if (json.decode(response)['info'] == "unfollowed successfully")
            isFollowing = false;
          else
            isFollowing = true;

          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("CHANGE-FOLLOW-STATUS-ERROR:${error.response.data}");

      }
    });
    yield ChangeFollowStatusSuccess(isFollowing);

  }
}
