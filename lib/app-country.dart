import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/country.dart';

class AppCountry extends ChangeNotifier {
  Country _chosenCountry;

  Country get chosenCountry => _chosenCountry;

  void changeCountry(Country country) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('chosen-country', json.encode(country.toJson()));
    _chosenCountry = country;
    notifyListeners();
  }

  fetchCountry() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('chosen-country'))
      _chosenCountry =
          Country.fromJson(json.decode(prefs.getString('chosen-country')));
  }
}
