

abstract class StartupEvents   {
  StartupEvents();


}

class AppStarted extends StartupEvents {
  AppStarted() : super();


}

class UpdatePreferenceFlow extends StartupEvents {
  final String route;
  UpdatePreferenceFlow(this.route) : super();


}
