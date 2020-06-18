import 'package:flutter/material.dart';
import 'package:tienda/model/country.dart';

class CountryListCard extends StatelessWidget {
  final List<Country> countries;

  CountryListCard({this.countries});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: new ListView.builder(
          shrinkWrap: true,
          itemCount: countries.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return ListTile(
              title: Text(
                countries[index].nameEnglish,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Image.asset(
                "assets/flags/ae.png",
                width: 30,
                height: 30,
              ),
              trailing: Text(countries[index].countryCode),
            );
          }),
    );
  }
}
