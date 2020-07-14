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
      vsync: this,
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
                          Spacer(
                            flex: 1,
                          ),
                          Container(
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('choose-your-country'),
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
                              : Column(
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
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: Text("fetching your location.."),
                                    )
                                  ],
                                ),
                          Spacer(
                            flex: 2,
                          ),
                          RaisedButton(
                              onPressed: () {
                                handleNext(context);
                              },
                              child: Text(AppLocalizations.of(context)
                                  .translate("continue"))),
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
                                currentCountry =
                                    appLanguage.appLocal == Locale('en')
                                        ? selectedCountry.nameEnglish
                                        : selectedCountry.nameArabic;
                                panelController.close();
                              });
                              appCountry.changeCountry(selectedCountry);
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
