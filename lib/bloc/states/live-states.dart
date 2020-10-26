import 'package:tienda/model/live-video.dart';

abstract class LiveStates {
  LiveStates();
}

class Loading extends LiveStates {
  Loading() : super();
}

class LoadCurrentLiveVideoListSuccess extends LiveStates {
  final List<LiveVideo> liveVideos;
  final LiveVideo featuredLiveContent;


  LoadCurrentLiveVideoListSuccess({this.liveVideos,this.featuredLiveContent}) : super();
}
class LoadAllLiveVideoListSuccess extends LiveStates {
  final List<LiveVideo> liveVideos;
  final LiveVideo featuredLiveContent;
  final Map<DateTime,List<LiveVideo>> groupedLiveContent;

  LoadAllLiveVideoListSuccess({this.liveVideos,this.featuredLiveContent,this.groupedLiveContent}) : super();
}