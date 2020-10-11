
abstract class StartupStates   {
  StartupStates();
}

class Initialized extends StartupStates {
  Initialized() : super();
}
class PreferenceFlowFetchComplete extends StartupStates {
  final String route;
  PreferenceFlowFetchComplete(this.route) : super();
}
