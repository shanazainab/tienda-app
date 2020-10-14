import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/bottom-nav-bar-events.dart';
import 'package:tienda/bloc/states/bottom-nav-bar-states.dart';

class BottomNavBarBloc extends Bloc<BottomNavBarEvents, BottomNavBarStates> {
  BottomNavBarBloc() : super(ChangeBottomNavBarStatusSuccess(0,false));

  @override
  Stream<BottomNavBarStates> mapEventToState(BottomNavBarEvents event) async* {
    if (event is ChangeBottomNavBarState) {
      yield ChangeBottomNavBarStatusSuccess(event.newIndex,event.hide);
    }
  }
}
