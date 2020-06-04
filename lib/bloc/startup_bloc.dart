import 'package:flutter_bloc/flutter_bloc.dart';

enum StartupEvent { AppStarted, dataFetch }
enum StartupState { initialized, dataReady, dataError }

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  @override
  StartupState get initialState => StartupState.initialized;

  @override
  Stream<StartupState> mapEventToState(StartupEvent event) async* {
    if (event == StartupEvent.AppStarted) {
      yield* _mapAppStartedToState();
    }
  }

  Stream<StartupState> _mapAppStartedToState() async* {

    print("######## DATA FETCH STARTED AND PROGRESSING");

    await Future.delayed(const Duration(seconds: 10), () {
      /// simulate a delay and check
    });
    print("######## DATA FETCH COMPLETE");

    yield StartupState.dataReady;

  }
}
