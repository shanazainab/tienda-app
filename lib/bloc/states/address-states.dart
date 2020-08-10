import 'package:equatable/equatable.dart';
import 'package:tienda/model/delivery-address.dart';

abstract class AddressStates {
  AddressStates();
}

class Loading extends AddressStates {
  Loading() : super();
}

class LoadAddressSuccess extends AddressStates {
  final List<DeliveryAddress> deliveryAddresses;

  LoadAddressSuccess({this.deliveryAddresses}) : super();
}

class DeleteAddressSuccess extends AddressStates {
  final List<DeliveryAddress> deliveryAddresses;

  DeleteAddressSuccess({this.deliveryAddresses}) : super();
}

class AuthorizationFailed extends AddressStates {
  AuthorizationFailed() : super();
}

class AddressEmpty extends AddressStates {
  AddressEmpty() : super();
}
