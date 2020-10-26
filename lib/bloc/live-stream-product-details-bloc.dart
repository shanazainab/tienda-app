import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/states/live-stream-states.dart';

class LiveStreamProductDetailsBloc
    extends Bloc<LiveStreamEvents, LiveStreamStates> {
  LiveStreamProductDetailsBloc() : super(Loading());

  @override
  Stream<LiveStreamStates> mapEventToState(LiveStreamEvents event) async* {
    if (event is ShowProduct) {
      yield ShowProductSuccess(event.product);
    }
  }
}
