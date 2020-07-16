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
  final DeliveryAddress deliveryAddress;
  AddSavedAddress({this.deliveryAddress}) : super();

  @override
  List<Object> get props => [deliveryAddress];
}

class EditSavedAddress extends AddressEvents {
  final DeliveryAddress deliveryAddress;
  EditSavedAddress({this.deliveryAddress}) : super();

  @override
  List<Object> get props => [deliveryAddress];
}

class DeleteSavedAddress extends AddressEvents {
  final int deliveryAddressId;
  DeleteSavedAddress({this.deliveryAddressId}) : super();

  @override
  List<Object> get props => [deliveryAddressId];
}
