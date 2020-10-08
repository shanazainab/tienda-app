import 'package:rxdart/rxdart.dart';


class FullScreenVideoControls {
  FullScreenVideoControls._privateConstructor();

  static final FullScreenVideoControls _instance = FullScreenVideoControls._privateConstructor();

  factory FullScreenVideoControls() {
    return _instance;
  }

  final showFullScreen = new BehaviorSubject<bool>();

  updateVideoView(bool show) {
    showFullScreen.sink.add(show);
  }
}
