import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: new FlareActor("assets/images/heart-animation.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "Start")));
  }
}
