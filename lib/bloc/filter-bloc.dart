import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/filter-events.dart';
import 'package:tienda/bloc/states/filter-states.dart';


class FilterBloc extends Bloc<FilterEvents, FilterStates> {
  FilterBloc() : super(Loading());




  @override
  Stream<FilterStates> mapEventToState(FilterEvents event) async* {
    if (event is LoadFilters) {
      yield* _mapLoadFiltersToStates(event);
    }
  }

  Stream<FilterStates> _mapLoadFiltersToStates(LoadFilters event) async* {

    yield LoadFilterSuccess(event.filters);

  }
}