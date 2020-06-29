import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/states/home-states.dart';

import 'events/home-events.dart';

class CategoryBlock extends Bloc<HomeEvents, HomeStates> {


  @override
  HomeStates get initialState => Loading();

  @override
  Stream<HomeStates> mapEventToState(HomeEvents event) async* {
    if (event is FetchHomeData) {
      yield* _mapFetchHomeDataToStates(event);
    }
  }

  Stream<HomeStates> _mapFetchHomeDataToStates(FetchHomeData event) async* {

    yield LoadDataFail("");

  }
}