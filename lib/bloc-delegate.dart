import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class TrackBlocDelegate extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    Logger().d("@@@@@@@:$transition");
    super.onTransition(bloc, transition);
  }
  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    Logger().e("@@@@@@@:$error");
    super.onError(cubit, error, stackTrace);
  }

}
