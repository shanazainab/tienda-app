import 'package:flutter/material.dart';
import 'package:flutter_playout/audio.dart';
import 'package:flutter_playout/player_state.dart';
import 'package:tienda/view/live-stream/video-playout.dart';

class PlayoutExample extends StatefulWidget {
  @override
  _PlayoutExampleState createState() => _PlayoutExampleState();
}

class _PlayoutExampleState extends State<PlayoutExample> {
  PlayerState _desiredState = PlayerState.PLAYING;
  bool _showPlayerControls = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: ListView(
          children: <Widget>[



          ],
        ),
      ),
    );
  }
}
