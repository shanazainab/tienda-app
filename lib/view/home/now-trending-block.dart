import 'package:flutter/material.dart';
import 'package:tienda/localization.dart';

class NowTrendingBlock extends StatelessWidget {
  const NowTrendingBlock({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(AppLocalizations.of(context).translate('now-trending'),
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 20)),
            )),
        Container(
          height: 100,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                  ),
                );
              }
          ),
        ),
      ],
    );
  }
}