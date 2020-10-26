import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/model/country.dart';

typedef OnClose = Function();

class CountryListCard extends StatelessWidget {
  final List<Country> countries;

  final Function(Country) function;

  final OnClose onClose;

  CountryListCard({this.function, this.countries, this.onClose});

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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Choose Country",
                    style: TextStyle(
                      color: Color(0xff282828),
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0,
                    )),
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      onClose();
                    })
              ],
            ),
          ),
          Expanded(
            child: new ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
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
          ),
        ],
      ),
    );
  }
}
