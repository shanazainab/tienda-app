import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/startup-bloc.dart';
import 'package:tienda/localization.dart';

import '../../app-language.dart';

class LanguagePreferencePage extends StatefulWidget {
  @override
  _LanguagePreferencePageState createState() => _LanguagePreferencePageState();
}

class _LanguagePreferencePageState extends State<LanguagePreferencePage> {
  bool isEnglishSelected = true;

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context).translate("pick-your-language"),
              style: TextStyle(fontSize: 18),
            ),
          ),
          Center(
            child: Container(
                height: MediaQuery.of(context).size.height - 300,
                width: 200,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        setState(() {
                          isEnglishSelected = true;
                        });
                        appLanguage.changeLanguage(Locale("en"));
                      },
                      selected: isEnglishSelected,
                      title: Text("English"),
                      trailing: isEnglishSelected ? Icon(Icons.check) : null,
                    ),
                    ListTile(
                      onTap: () {
                        setState(() {
                          isEnglishSelected = false;
                        });
                        appLanguage.changeLanguage(Locale("ar"));
                      },
                      trailing: !isEnglishSelected ? Icon(Icons.check) : null,
                      selected: !isEnglishSelected,
                      title: Text("العربية"),
                    ),
                  ],
                )),
          ),
          Container(
            height: 100,
            alignment: Alignment.center,
            child: SizedBox(
              height: 46,
              width: MediaQuery.of(context).size.width - 100,
              child: RaisedButton(
                onPressed: () {
                  handleNext(context);
                },
                child: Text(
                  AppLocalizations.of(context).translate("continue"),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleNext(context) {
    if (isEnglishSelected) {
      FirebaseAnalytics()
          .logEvent(name: 'LANGUAGE_PREF', parameters: {'lang_code': 'en'});
    } else {
      FirebaseAnalytics()
          .logEvent(name: 'LANGUAGE_PREF', parameters: {'lang_code': 'ar'});
    }

    BlocProvider.of<StartupBloc>(context)
        .add(UpdatePreferenceFlow("/languagePreferencePage"));

    Navigator.pushNamed(context, '/countryChoosePage');
  }
}
