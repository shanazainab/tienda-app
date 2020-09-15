import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/loading-events.dart';
import 'package:tienda/bloc/states/loading-states.dart';

class LoadingBloc extends Bloc<LoadingEvents, LoadingStates> {
  LoadingBloc() : super(NotLoading());

  @override
  Stream<LoadingStates> mapEventToState(LoadingEvents event) async* {
    if (event is StartLoading) {
      yield AppLoading();
    }
    if (event is StopLoading) {
      yield NotLoading();
    }
  }
}
