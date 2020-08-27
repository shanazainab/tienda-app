import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/model/country.dart';

class CountryListCard extends StatelessWidget {
  final List<Country> countries;

  final Function(Country) function;

  CountryListCard({this.function, this.countries});

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Card(
      elevation: 20,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(16),
        topLeft: Radius.circular(16),
      )),
      //color: Colors.grey[200],
      child: new ListView.builder(
          shrinkWrap: true,
          itemCount: countries.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return ListTile(
              onTap: () {
                function(countries[index]);
              },
              title: Text(
                appLanguage.appLocal == Locale('en')
                    ? countries[index].nameEnglish
                    : countries[index].nameArabic,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Image.network(
                "${GlobalConfiguration().getString("imageURL")}${countries[index].thumbnail}",
                width: 30,
                height: 20,
                fit: BoxFit.cover,
              ),
              trailing: Text(
                "+${NumberFormat().format(int.parse(countries[index].countryCode))}",
                locale: Locale('ar'),
              ),
            );
          }),
    );
  }
}
