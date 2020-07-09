import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app-language.dart';
import '../../localization.dart';

class FeaturedSellersList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(AppLocalizations.of(context).translate('featured-sellers'),
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 20))),
          SizedBox(
            height: appLanguage.appLocal == Locale('en')?230:250,
            child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext cxt, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,

                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 160,
                            width: 120,
                            color: Colors.grey[200],
                          ),
                        ),
                        Text("Seller Name"),
                        Text("Rating")
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
