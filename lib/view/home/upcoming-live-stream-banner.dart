import 'package:flutter/material.dart';
import 'package:tienda/localization.dart';

class UpComingLiveStreamBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("STREAMING TIME"),
            Text("00:45:04"),
          ],
        ),
      ),
    );
  }
}
