import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/states/live-stream-states.dart';

class LiveStreamCheckoutBloc extends Bloc<LiveStreamEvents, LiveStreamStates> {
  LiveStreamCheckoutBloc() : super( Loading());



  @override
  Stream<LiveStreamStates> mapEventToState(LiveStreamEvents event) async* {
    if (event is ShowProduct) {
      yield* _mapFetchHomeDataToStates(event);
    }
  }

  Stream<LiveStreamStates> _mapFetchHomeDataToStates(ShowProduct event) async* {
    yield ShowProductSuccess(event.product);
  }
}
