import 'package:rxdart/rxdart.dart';

class LiveChatContainerController{
  LiveChatContainerController._privateConstructor();

  static final LiveChatContainerController _instance = LiveChatContainerController._privateConstructor();

  factory LiveChatContainerController() {
    return _instance;
  }

  final containerHeight = new BehaviorSubject<double>();

  updateHeight(double height) {
    containerHeight.sink.add(height);
  }
}