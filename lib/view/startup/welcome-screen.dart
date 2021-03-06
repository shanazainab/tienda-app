import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/startup-bloc.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Stack(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.only(bottom: 26.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                height: 46,
                child: RaisedButton(
                  onPressed: () {
                    handleNext(context);
                  },
                  child: Text(
                    "EXPLORE THE APP",
                    style: TextStyle(color: Colors.grey[200]),
                  ),
                ),
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
