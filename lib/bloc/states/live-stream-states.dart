
import 'package:tienda/model/live-response.dart';

abstract class LiveStreamStates {
  LiveStreamStates();
}

class Loading extends LiveStreamStates{

}
class JoinLiveSuccess extends LiveStreamStates {
  final LiveResponse liveResponse;

  JoinLiveSuccess(this.liveResponse) : super();
}
