import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/startup-bloc.dart';

import '../../app-language.dart';

class LanguagePreferencePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Choose Your Language',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 60,
              ),
              CupertinoPicker(
                  itemExtent: 60,
                  diameterRatio: 2,
                  backgroundColor: Colors.white,
                  looping: true,
                  useMagnifier: true,
                  onSelectedItemChanged: (item) {
                    print('ITEM SELECTED FROM PICKER: $item');

                    ///0: English
                    ///1: Arabic

                    item == 0
                        ? appLanguage.changeLanguage(Locale("en"))
                        : appLanguage.changeLanguage(Locale("ar"));
                  },
                  children: [
                    Text("English"),
                    Text(
                      "العربية",
                      locale: Locale.fromSubtags(
                          countryCode: 'ae', languageCode: 'ar'),
                      style: TextStyle(
                          locale: Locale.fromSubtags(
                              countryCode: 'ae', languageCode: 'ar')),
                    ),
                  ]),
            ],
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RaisedButton(
                onPressed: () {
                  handleNext(context);
                },
                child: Text("CONTINUE"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleNext(context) {
    BlocProvider.of<StartupBloc>(context)
        .add(UpdatePreferenceFlow("/languagePreferencePage"));

    Navigator.pushNamed(context, '/countryChoosePage');
  }
}
