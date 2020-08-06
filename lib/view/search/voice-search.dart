import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

typedef OnVoiceInput =  Function(String);

class VoiceSearch extends StatefulWidget {
  final OnVoiceInput onVoiceInput;

  VoiceSearch({this.onVoiceInput});

  @override
  _VoiceSearchState createState() => _VoiceSearchState();
}

class _VoiceSearchState extends State<VoiceSearch> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "What You are Looking for?";
  String lastError = "";
  String lastStatus = "";
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 30),
          child: Text(
            lastWords,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onLongPress: () {
              print("ON FORCE PRESS START");
              startListening();
            },
            onLongPressEnd: (end) {
              print("ON FORCE PRESS END");

              stopListening();

            },
            child: Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                      blurRadius: .26,
                      spreadRadius: level * 1.5,
                      color: Colors.black.withOpacity(.05))
                ],
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Icon(Icons.mic),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Center(
          child: Text(lastError),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: speech.isListening
                ? Text(
                    "I'm listening...",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : Text(
                    'Press and hold to speak',
                    style: TextStyle(color: Colors.grey),
                  ),
          ),
        ),
      ]),
    );
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        localeId: Intl.systemLocale,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true,
        onDevice: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });

    widget.onVoiceInput(lastWords);
    Navigator.of(context).pop();

  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
      print(lastWords);
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    // print(
    // "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }
}
