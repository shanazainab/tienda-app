import 'package:equatable/equatable.dart';

abstract class StartupStates extends Equatable {
  StartupStates();

  @override
  List<Object> get props => null;
}

class Initialized extends StartupStates {
  Initialized() : super();
}
class PreferenceFlowFetchComplete extends StartupStates {
  final String route;
  PreferenceFlowFetchComplete(this.route) : super();
}

class DataReady extends StartupStates {
  DataReady() : super();
}

class DataError extends StartupStates {
  DataError() : super();
}
