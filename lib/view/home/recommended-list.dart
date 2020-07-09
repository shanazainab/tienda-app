import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app-language.dart';
import '../../localization.dart';

class RecommendedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(AppLocalizations.of(context).translate('recommended-for-you'),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20))),
          SizedBox(
            height:appLanguage.appLocal == Locale('en')?190:240,
            child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext cxt, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 120,
                            width: 120,
                            color: Colors.lightBlue,
                          ),
                        ),
                        Text("Item Name"),
                        Text("AED XXX")
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
