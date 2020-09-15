
abstract class LoadingEvents {
  LoadingEvents();
}

class StartLoading extends LoadingEvents {
  StartLoading() : super();
}
class StopLoading extends LoadingEvents {
  StopLoading() : super();
}