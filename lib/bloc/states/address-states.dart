import 'package:equatable/equatable.dart';
import 'package:tienda/model/address.dart';

abstract class AddressStates extends Equatable {
  AddressStates();

  @override
  List<Object> get props => null;
}

class Loading extends AddressStates {
  Loading() : super();
}

class LoadAddressSuccess extends AddressStates {
  final List<DeliveryAddress> deliveryAddresses;

  LoadAddressSuccess({this.deliveryAddresses}) : super();

  @override
  List<Object> get props => [deliveryAddresses];
}

class AddAddressSuccess extends AddressStates {
  AddAddressSuccess() : super();

  @override
  List<Object> get props => [];
}

class EditAddressSuccess extends AddressStates {
  EditAddressSuccess() : super();

  @override
  List<Object> get props => [];
}

class DeleteAddressSuccess extends AddressStates {
  DeleteAddressSuccess() : super();

  @override
  List<Object> get props => [];
}
