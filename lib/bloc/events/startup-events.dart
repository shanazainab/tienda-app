import 'package:equatable/equatable.dart';

abstract class StartupEvents extends Equatable {
  StartupEvents();

  @override
  List<Object> get props => null;
}

class AppStarted extends StartupEvents {
  AppStarted() : super();

  @override
  List<Object> get props => null;
}

class UpdatePreferenceFlow extends StartupEvents {
  final String route;
  UpdatePreferenceFlow(this.route) : super();

  @override
  List<Object> get props => null;
}

class DataFetch extends StartupEvents {
  DataFetch() : super();

  @override
  List<Object> get props => null;
}

class CheckLogInStatus extends StartupEvents {
  CheckLogInStatus() : super();

  @override
  List<Object> get props => null;
}