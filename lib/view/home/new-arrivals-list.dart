import 'package:flutter/material.dart';

import '../../localization.dart';

class NewArrivalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(AppLocalizations.of(context).translate('new-arrival'),
                  style: TextStyle(color: Colors.black, fontSize: 20))),
          Container(
            height: 200,
            child: ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
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
                        Text(
                          'Item Name',
                        ),
                        Text(
                          'AED XXX',
                        )
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
