import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/startup-bloc.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Stack(
        children: <Widget>[
          Center(
            child: Text(
              'Intro Slides',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom:20.0),
              child: RaisedButton(
                onPressed: () {
                  handleNext(context);
                },
                child: Text("GET STARTED"),
              ),
            ),
          ),
        ],
      )),
    );
  }

  void handleNext(context) {
    BlocProvider.of<StartupBloc>(context)
        .add(UpdatePreferenceFlow("/welcomeScreen"));

    Navigator.pushNamed(context, '/languagePreferencePage');
  }
}
