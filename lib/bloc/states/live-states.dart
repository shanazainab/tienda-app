import 'package:tienda/model/live-contents.dart';

abstract class LiveStates {
  LiveStates();
}

class Loading extends LiveStates {
  Loading() : super();
}

class LoadLiveVideoListSuccess extends LiveStates {
  final List<LiveContent> liveContents;
  final LiveContent featuredLiveContent;

  LoadLiveVideoListSuccess({this.liveContents,this.featuredLiveContent}) : super();
}
