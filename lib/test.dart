import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:tienda/view/live-stream/live-stream-screen.dart';

class TestFile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: RaisedButton(
        onPressed: (){

        },
        child: Text("START"),
      ),
      body: Container(
        width: 100,
        height: 500,
        child: FlareActor(
            "assets/images/test2.flr",
            fit: BoxFit.contain,
            shouldClip: true,
            snapToEnd: true,
            callback: (value) {
              print("HEART ANIMATION END: $value");
            },
            alignment: Alignment.bottomRight,
            animation: "Start"),
      ),
    );
  }
}
