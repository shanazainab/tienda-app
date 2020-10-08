import 'package:tienda/model/delivery-address.dart';

abstract class AddressEvents {
  AddressEvents();


}

class LoadSavedAddress extends AddressEvents {
  LoadSavedAddress() : super();


}

class AddSavedAddress extends AddressEvents {
  final List<DeliveryAddress> deliveryAddresses;
  final DeliveryAddress deliveryAddress;

  AddSavedAddress({this.deliveryAddress,this.deliveryAddresses}) : super();


}

class EditSavedAddress extends AddressEvents {
  final List<DeliveryAddress> deliveryAddresses;
  final DeliveryAddress deliveryAddress;

  EditSavedAddress({this.deliveryAddresses,this.deliveryAddress}) : super();


}

class DeleteSavedAddress extends AddressEvents {
  final List<DeliveryAddress> deliveryAddresses;
  final int deliveryAddressId;

  DeleteSavedAddress({this.deliveryAddresses, this.deliveryAddressId})
      : super();


}
