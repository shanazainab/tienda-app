import 'package:rxdart/rxdart.dart';

class Controls {
  bool show;
  bool isPlaying;

  bool showProgress;

  Controls({this.show, this.isPlaying, this.showProgress});
}

class VideoControls {
  VideoControls._privateConstructor();

  static final VideoControls _instance = VideoControls._privateConstructor();

  factory VideoControls() {
    return _instance;
  }

  final controls = new BehaviorSubject<Controls>();

  updateControls(Controls newControls) {
    controls.sink.add(newControls);
  }
}
