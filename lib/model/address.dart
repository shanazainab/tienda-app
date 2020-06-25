import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryAddress {
  String id;
  String name;
  int mobileNumber;
  String address;
  LatLng latLng;
  String instruction;
  bool isVilla;
  bool isApartment;
  bool isOffice;
  bool isDefault;
  ApartmentAddress apartmentAddress;
  VillaAddress villaAddress;

  DeliveryAddress(
      {this.id,
      this.address,
      this.latLng,
      this.instruction,
      this.isVilla,
      this.isApartment,
      this.apartmentAddress,
      this.villaAddress,
      this.isDefault});
}

class ApartmentAddress {
  String buildingName;
  String floorNumber;
  String apartmentNumber;

  ApartmentAddress({this.buildingName, this.floorNumber, this.apartmentNumber});
}

class VillaAddress {
  String streetName;
  String villaName;
  String villaNumber;

  VillaAddress({this.streetName, this.villaName, this.villaNumber});
}
