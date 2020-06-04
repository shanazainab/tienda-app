import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/startup_bloc.dart';
import 'package:tienda/track_bloc_delegate.dart';
import 'package:tienda/view/home/home_page.dart';
import 'package:tienda/view/introduction/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ///Enable firebase crash analytics
  Crashlytics.instance.enableInDevMode = true;

  ///To track bloc pattern states and transitions
  BlocSupervisor.delegate = TrackBlocDelegate();

  ///add firebase crash analytics to entire MaterialApp
  runZonedGuarded(() async {
    runApp(
      BlocProvider(
        create: (context) => StartupBloc()
          ..add(StartupEvent.AppStarted),
        child: App(),
      ),
    );
  }, Crashlytics.instance.recordError);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<StartupBloc, StartupState>(
        builder: (context, state) {
          if (state == StartupState.initialized) {
            return SplashScreen();
          }
          if (state == StartupState.dataReady) {
            return HomePage();
          }
          else
            return Container();
        },
      ),
    );
  }



}


