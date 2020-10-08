import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/states/live-stream-states.dart';

class LiveStreamProductBloc extends Bloc<LiveStreamEvents, LiveStreamStates> {
  LiveStreamProductBloc() : super( Loading());
  
  @override
  Stream<LiveStreamStates> mapEventToState(LiveStreamEvents event) async* {
    if (event is UpdateWishListProducts) {
      yield* _mapUpdateWishListProductToStates(event);
    }
  }

  Stream<LiveStreamStates> _mapUpdateWishListProductToStates(UpdateWishListProducts event) async* {
    yield UpdateWishListProductsSuccess(event.products);
  }
}
