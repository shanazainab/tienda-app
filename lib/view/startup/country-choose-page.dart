import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tienda/app-country.dart';
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

class _CountryChoosePageState extends State<CountryChoosePage>
    with SingleTickerProviderStateMixin {
  String currentCountry = "";
  PreferenceBloc preferenceBloc = new PreferenceBloc();
  bool viewCountryList = false;
  final GlobalKey key = new GlobalKey();
  String currentLocationCountry;
  PanelController panelController = new PanelController();
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preferenceBloc.add(FetchCountryList());
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this
    )..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 1.5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    var appCountry = Provider.of<AppCountry>(context);

    return BlocProvider<PreferenceBloc>(
        create: (context) => preferenceBloc,
        child: BlocListener<PreferenceBloc, PreferenceStates>(
            listener: (context, state) async {
              if (state is LoadCountryListSuccess) {
                currentLocationCountry = await getTheCurrentLocation();
                if (appLanguage.appLocal == Locale('en')) {
                  setState(() {
                    currentCountry = currentLocationCountry;
                  });
                  _controller.stop(canceled: true);
                } else {
                  print("LANGUAGE IN PREFERENCE: ARABIC");
                  for (final country in state.countries) {
                    if (country.nameEnglish.toLowerCase() ==
                        currentLocationCountry.toLowerCase()) {
                      print("ITS EQUAL");

                      setState(() {
                        currentCountry = country.nameArabic;
                      });
                    }
                  }
                }
                for (final country in state.countries) {
                  if (country.nameEnglish.toLowerCase() ==
                      currentLocationCountry.toLowerCase()) {
                    appCountry.changeCountry(country);
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
                          Container(
                            alignment: Alignment.center,
                            height: 200,
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('choose-your-country'),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          currentCountry.length > 0
                              ? Container(
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.height - 300,
                                  child: Text(
                                    currentCountry,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.height - 300,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SlideTransition(
                                        position: _offsetAnimation,
                                        child: Image.asset(
                                          "assets/icons/address-pin.png",
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 40.0),
                                        child: Text("fetching your location.."),
                                      )
                                    ],
                                  ),
                                ),
                          Container(
                            height: 100,
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Tap to choose country",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                                SizedBox(
                                  height: 46,
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: RaisedButton(
                                      onPressed: () {
                                        handleNext(context);
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate("continue"),
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                              ],
                            ),
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
                              appCountry.changeCountry(selectedCountry);

                              setState(() {
                                currentCountry =
                                    appLanguage.appLocal == Locale('en')
                                        ? selectedCountry.nameEnglish
                                        : selectedCountry.nameArabic;
                                currentLocationCountry =
                                    selectedCountry.nameEnglish;
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
    ///Log country of preference

    FirebaseAnalytics().logEvent(
        name: 'COUNTRY_PREF',
        parameters: {'country_name': currentLocationCountry});

    if (currentCountry != "") {
      BlocProvider.of<StartupBloc>(context)
          .add(UpdatePreferenceFlow("/countryChoosePage"));

      Navigator.pushNamed(context, '/categorySelectionPage');
    }
  }

  Future<String> getTheCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    Logger().d("CURRENT:::LOCATION::${placeMark[0].country}");

    return placeMark[0].country;
  }
}
