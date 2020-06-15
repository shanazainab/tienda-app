import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/startup-bloc.dart';

class CountryChoosePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Country Choose',style: TextStyle(
            fontSize: 24
          ),),
           Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: RaisedButton(
              onPressed: () {
                handleNext(context);
              },
              child: Text("NEXT"),
            ),
          ),
        ],
      )),
    );
  }

  void handleNext(BuildContext context) {
     BlocProvider.of<StartupBloc>(context)
        .add(UpdatePreferenceFlow("/countryChoosePage"));
    Navigator.pushNamed(context, '/languagePreferencePage');
  }
}
