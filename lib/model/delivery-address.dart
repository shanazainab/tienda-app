class DeliveryAddress {
  String id;
  String name;
  int mobileNumber;
  String addressType;
  String address;
  double lat;
  double lng;
  String instruction;
  bool isDefault;
  String buildingName;
  String buildingNumber;
  String floorNUmber;
  String city;
  String country;
  String villaName;

  DeliveryAddress(
      {this.id,
      this.name,
      this.mobileNumber,
      this.addressType,
      this.address,
      this.lat,
      this.lng,
      this.instruction,
      this.isDefault,
      this.villaName,
      this.buildingName,
      this.buildingNumber,
      this.floorNUmber,
      this.city,
      this.country});

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
        addressType: json['address_type'],
        villaName: json['apartment'],
        buildingName: json['building_name'],
        city: json['city'],
        instruction: json['comment'],
        country: json['country'],
        floorNUmber: json['floor'],
        name: json['full_name'],
        address: json['long_address'],
        lat: json['map_lat'],
        lng: json['map_long'],
        mobileNumber: json['phone_number'],
        isDefault: json['is_default']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_type'] = this.addressType;
    data['apartment'] = this.villaName;
    data['building_name'] = this.buildingName;
    data['city'] = this.city;
    data['comment'] = this.instruction;
    data['country'] = this.country;
    data['floor'] = this.floorNUmber;
    data['full_name'] = this.name;
    data['long_address'] = this.address;
    data['map_lat'] = this.lat;
    data['map_long'] = this.lng;
    data['is_default'] = this.isDefault;
    data['phone_number'] = this.mobileNumber;
    return data;
  }

  @override
  String toString() {
    return 'DeliveryAddress{id: $id, name: $name, mobileNumber: $mobileNumber, addressType: $addressType, address: $address, lat: $lat, lng: $lng, instruction: $instruction, isDefault: $isDefault, buildingName: $buildingName, buildingNumber: $buildingNumber, floorNUmber: $floorNUmber, city: $city, country: $country, villaName: $villaName}';
  }
}
