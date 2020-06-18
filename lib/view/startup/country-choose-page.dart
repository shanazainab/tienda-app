import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/events/preference-events.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/preference-bloc.dart';
import 'package:tienda/bloc/startup-bloc.dart';
import 'package:tienda/bloc/states/preference-states.dart';
import 'package:tienda/localization.dart';

import 'country-list-card.dart';

class CountryChoosePage extends StatefulWidget {
  @override
  _CountryChoosePageState createState() => _CountryChoosePageState();
}

class _CountryChoosePageState extends State<CountryChoosePage> {
  String currentCountry = "";
  PreferenceBloc preferenceBloc = new PreferenceBloc();
  bool viewCountryList = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preferenceBloc.add(FetchCountryList());
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return BlocProvider<PreferenceBloc>(
        create: (context) => preferenceBloc,
        child: BlocListener<PreferenceBloc, PreferenceStates>(
            listener: (context, state) async {
              if (state is LoadCountryListSuccess) {
                String currentLocationCountry = await getTheCurrentLocation();
                if (appLanguage.appLocal == Locale('en')) {
                  setState(() {
                    currentCountry = currentLocationCountry;
                  });
                } else {
                  print("LANGUAGE IN PREFERENCE: ARABIC");
                  for (final country in state.countries) {
                    print(country.nameArabic);
                    if (country.nameEnglish.toLowerCase() ==
                        currentLocationCountry.toLowerCase()) {
                      print("ITS EQUAL");

                      setState(() {
                        currentCountry = country.nameArabic;
                      });
                    }
                  }
                }
              }
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: InkWell(
                onTap: () {
                  print("TAPPED");
                  setState(() {
                    viewCountryList = !viewCountryList;
                  });
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)
                                  .translate('country-message'),
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Text(
                              currentCountry,
                              style: TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
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
                      Visibility(
                        visible: viewCountryList,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: BlocBuilder<PreferenceBloc, PreferenceStates>(
                              builder: (context, state) {
                            if (state is LoadCountryListSuccess)
                              return CountryListCard(
                                countries: state.countries,
                              );
                            else
                              return Container(
                                height: 0,
                              );
                          }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  void handleNext(BuildContext context) {
    BlocProvider.of<StartupBloc>(context)
        .add(UpdatePreferenceFlow("/countryChoosePage"));
    Navigator.pushNamed(context, '/categorySelectionPage');
  }

  Future<String> getTheCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    return placeMark[0].country;
  }
}
