import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
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
  final GlobalKey key = new GlobalKey();

  PanelController panelController = new PanelController();

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
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              key: key,
              body: Stack(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      panelController.isPanelOpen
                          ? panelController.close()
                          : panelController.open();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Spacer(
                            flex: 1,
                          ),
                          Container(
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('country-message'),
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Spacer(
                            flex: 2,
                          ),
                          currentCountry.length > 0
                              ? Text(
                                  currentCountry,
                                  style: TextStyle(fontSize: 24),
                                )
                              : FadingText('fetching your location...'),
                          Spacer(
                            flex: 2,
                          ),
                          RaisedButton(
                              onPressed: () {
                                handleNext(context);
                              },
                              child: Text("CONTINUE")),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SlidingUpPanel(
                      controller: panelController,
                      defaultPanelState: PanelState.CLOSED,
                      minHeight: 0,
                      maxHeight: 400,
                      panel: BlocBuilder<PreferenceBloc, PreferenceStates>(
                          builder: (context, state) {
                        if (state is LoadCountryListSuccess)
                          return CountryListCard(
                            countries: state.countries,
                            function: (selectedCountry) {
                              setState(() {
                                currentCountry = selectedCountry;
                                panelController.close();
                              });
                            },
                          );
                        else
                          return Container(
                            height: 0,
                          );
                      }))
                ],
              ),
            )));
  }

  void handleNext(BuildContext context) {
    BlocProvider.of<StartupBloc>(context)
        .add(UpdatePreferenceFlow("/countryChoosePage"));
    Navigator.pushNamed(context, '/categorySelectionPage');
  }

  Future<String> getTheCurrentLocation() async {
    Logger().d("GET LOCATION");

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    Logger().d("CURRENT:::LOCATION::${placeMark[0].country}");

    return placeMark[0].country;
  }
}
