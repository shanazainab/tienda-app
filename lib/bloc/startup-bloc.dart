import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/bloc/states/startup-states.dart';
import 'package:tienda/console-logger.dart';
import 'package:tienda/controller/login-controller.dart';

import 'events/startup-events.dart';

class StartupBloc extends Bloc<StartupEvents, StartupStates> {
  ConsoleLogger consoleLogger = new ConsoleLogger();
  LoginController loginController;

  StartupBloc() {
    loginController = new LoginController();
  }

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
    if (event is CheckLogInStatus) {
      yield* _mapCheckLoginStatusToState();
    }
  }

  Stream<StartupStates> _mapAppStartedToState() async* {
    ///{ "/welcomeScreen":true,
    ///   "/countryChoosePage":false,
    ///   "/languagePreferencePage":false,
    ///   "/categorySelectionPage":false }

    ///CHECK LOGIN STATUS

    await loginController.checkLoginStatus();

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

  Stream<StartupStates> _mapCheckLoginStatusToState() async* {
    bool isLoggedIn = await loginController.checkLoginStatus();

    consoleLogger.printResponse("#########LOGIN-STATUS: $isLoggedIn");
    switch (isLoggedIn) {
      case true:
        yield LogInStatusResponse(isLoggedIn: true);
        break;
      case false:
        yield LogInStatusResponse(isLoggedIn: false);
        break;
    }
  }

  Future<void> _updateThePreferenceFlow(String route) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> prefMap =
        json.decode(prefs.getString("preference-flow"));

    prefMap.update(route, (value) => true);

    prefs.setString("preference-flow", json.encode(prefMap));
  }
}
