import 'package:flutter/material.dart';
import 'package:tienda/model/country.dart';

class CountryListCard extends StatelessWidget {
  final List<Country> countries;

  final Function(String) function;
  CountryListCard({this.function,this.countries});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        )
      ),
      //color: Colors.grey[200],
      child: new ListView.builder(
          shrinkWrap: true,
          itemCount: countries.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return ListTile(
              onTap: (){

                function(countries[index].nameEnglish);
              },
              title: Text(
                countries[index].nameEnglish,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Image.asset(
                "assets/icons/flag.png",
                width: 30,
                height: 30,
              ),
              trailing: Text("+${countries[index].countryCode}"),
            );
          }),
    );
  }
}
