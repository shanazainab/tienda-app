import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/bottom-nav-bar-events.dart';
import 'package:tienda/bloc/states/bottom-nav-bar-states.dart';

class BottomNavBarBloc extends Bloc<BottomNavBarEvents, BottomNavBarStates> {
  BottomNavBarBloc() : super(ChangeBottomNavBarIndexSuccess(0));

  @override
  Stream<BottomNavBarStates> mapEventToState(BottomNavBarEvents event) async* {
    if (event is ChangeBottomNavBarIndex) {
      yield ChangeBottomNavBarIndexSuccess(event.index);
    }
  }
}
