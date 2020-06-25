import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/states/address-states.dart';

class AddressBloc extends Bloc<AddressEvents, AddressStates> {
  @override
  AddressStates get initialState => Loading();

  @override
  Stream<AddressStates> mapEventToState(AddressEvents event) async* {
    if (event is LoadSavedAddress) {
      yield* _mapLoadSavedAddressToStates(event);
    }
  }

  Stream<AddressStates> _mapLoadSavedAddressToStates(
      LoadSavedAddress event) async* {}
}
