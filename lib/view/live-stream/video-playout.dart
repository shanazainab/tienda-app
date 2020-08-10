import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_playout/multiaudio/HLSManifestLanguage.dart';
import 'package:flutter_playout/multiaudio/MultiAudioSupport.dart';
import 'package:flutter_playout/player_observer.dart';
import 'package:flutter_playout/player_state.dart';
import 'package:flutter_playout/video.dart';
import 'package:tienda/getManifestLanguage.dart';

class VideoPlayOut extends StatefulWidget {
  final PlayerState desiredState;
  final bool showPlayerControls;
  final String url;

  const VideoPlayOut({Key key, this.desiredState, this.showPlayerControls,this.url})
      : super(key: key);

  @override
  _VideoPlayOutState createState() => _VideoPlayOutState();
}

class _VideoPlayOutState extends State<VideoPlayOut>
    with PlayerObserver, MultiAudioSupport {
  List<HLSManifestLanguage> _hlsLanguages = List<HLSManifestLanguage>();

  @override
  void initState() {
    super.initState();
   // Future.delayed(Duration.zero, _getHLSManifestLanguages);
  }

//  Future<void> _getHLSManifestLanguages() async {
//    if (!Platform.isIOS && widget.url != null && widget.url.isNotEmpty) {
//      _hlsLanguages = await getManifestLanguages(widget.url);
//      setState(() {});
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          /* player */
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Video(
              autoPlay: true,
              showControls: widget.showPlayerControls,
              title: "MTA International",
              subtitle: "Reaching The Corners Of The Earth",
              preferredAudioLanguage: "eng",
              isLiveStream: true,
              position: 0,
              url: widget.url,
              onViewCreated: _onViewCreated,
              desiredState: widget.desiredState,
            ),
          ),
          /* multi language menu */
          _hlsLanguages.length < 2 && !Platform.isIOS
              ? Container()
              : Container(
            child: Row(
              children: _hlsLanguages
                  .map((e) => MaterialButton(
                child: Text(
                  e.name,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.white),
                ),
                onPressed: () {
                  setPreferredAudioLanguage(e.code);
                },
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _onViewCreated(int viewId) {
    listenForVideoPlayerEvents(viewId);
    enableMultiAudioSupport(viewId);
  }

  @override
  void onPlay() {
    // TODO: implement onPlay
    super.onPlay();
  }

  @override
  void onPause() {
    // TODO: implement onPause
    super.onPause();
  }

  @override
  void onComplete() {
    // TODO: implement onComplete
    super.onComplete();
  }

  @override
  void onTime(int position) {
    // TODO: implement onTime
    super.onTime(position);
  }

  @override
  void onSeek(int position, double offset) {
    // TODO: implement onSeek
    super.onSeek(position, offset);
  }

  @override
  void onDuration(int duration) {
    // TODO: implement onDuration
    super.onDuration(duration);
  }

  @override
  void onError(String error) {
    // TODO: implement onError
    super.onError(error);
  }
}