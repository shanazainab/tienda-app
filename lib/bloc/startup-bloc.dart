import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/bloc/states/startup-states.dart';

import 'events/startup-events.dart';

class StartupBloc extends Bloc<StartupEvents, StartupStates> {
  @override
  StartupStates get initialState => Initialized();

  @override
  Stream<StartupStates> mapEventToState(StartupEvents event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    }
    if (event is UpdatePreferenceFlow) {
      _updateThePreferenceFlow(event.route);
    }
  }

  Stream<StartupStates> _mapAppStartedToState() async* {
    ///{ "/welcomeScreen":true,
    ///   "/countryChoosePage":false,
    ///   "/languagePreferencePage":false,
    ///   "/categorySelectionPage":false }

    print("######## CHECKING LOGIN AND PREFERENCE FLOW");

    ///TODO:CHECK LOGIN STATUS

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String route = '/welcomeScreen';
    if (prefs.containsKey("preference-flow")) {
      Map<String, dynamic> prefMap =
          json.decode(prefs.getString("preference-flow"));
      var key = prefMap.keys
          .firstWhere((k) => prefMap[k] == false, orElse: () => null);
      if (key != null)
        route = key;
      else
        route = '/homePage';
    } else {
      Map<String, bool> prefMap = {
        "/welcomeScreen": false,
        "/countryChoosePage": false,
        "/languagePreferencePage": false,
        "/categorySelectionPage": false
      };
      prefs.setString("preference-flow", json.encode(prefMap));
    }

    yield PreferenceFlowFetchComplete(route);
  }

  Future<void> _updateThePreferenceFlow(String route) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> prefMap =
        json.decode(prefs.getString("preference-flow"));

    prefMap.update(route, (value) => true);

    prefs.setString("preference-flow", json.encode(prefMap));
  }
}
