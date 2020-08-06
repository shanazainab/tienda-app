import 'package:equatable/equatable.dart';
import 'package:tienda/model/delivery-address.dart';

abstract class AddressEvents extends Equatable {
  AddressEvents();

  @override
  List<Object> get props => null;
}

class LoadSavedAddress extends AddressEvents {
  LoadSavedAddress() : super();

  @override
  List<Object> get props => [];
}

class AddSavedAddress extends AddressEvents {
  final List<DeliveryAddress> deliveryAddresses;
  final DeliveryAddress deliveryAddress;

  AddSavedAddress({this.deliveryAddress,this.deliveryAddresses}) : super();

  @override
  List<Object> get props => [deliveryAddress];
}

class EditSavedAddress extends AddressEvents {
  final List<DeliveryAddress> deliveryAddresses;
  final DeliveryAddress deliveryAddress;

  EditSavedAddress({this.deliveryAddresses,this.deliveryAddress}) : super();

  @override
  List<Object> get props => [deliveryAddress];
}

class DeleteSavedAddress extends AddressEvents {
  final List<DeliveryAddress> deliveryAddresses;
  final int deliveryAddressId;

  DeleteSavedAddress({this.deliveryAddresses, this.deliveryAddressId})
      : super();

  @override
  List<Object> get props => [deliveryAddressId];
}
