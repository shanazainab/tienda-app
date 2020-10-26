class DeliveryAddress {
  DeliveryAddress({
    this.id,
    this.fullName,
    this.country,
    this.city,
    this.longAddress,
    this.phoneNumber,
    this.mapLat,
    this.mapLong,
    this.apartment,
    this.buildingName,
    this.floor,
    this.customerId,
    this.comment,
    this.addressType,
    this.isDefault,
  });

  int id;
  String fullName;
  String country;
  String city;
  String longAddress;
  String phoneNumber;
  double mapLat;
  double mapLong;
  String apartment;
  String buildingName;
  String floor;
  int customerId;
  String comment;
  String addressType;
  bool isDefault;

  // "",
  // "",
  // "",
  // "",
  // "",
  // "",
  // "apartment",
  // "building_name",
  // "floor",
  // "",
  // "",
  // "",
  // "
  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
        id: json["id"],
        fullName: json["full_name"],
        country: json["country"],
        city: json["city"],
        longAddress: json["long_address"],
        phoneNumber: json["phone_number"],
        mapLat: json["map_lat"].toDouble(),
        mapLong: json["map_long"].toDouble(),
        apartment: json["apartment"],
        buildingName: json["building_name"],
        floor: json["floor"],
        customerId: json["customer_id"],
        comment: json["comment"],
        addressType: json["address_type"],
        isDefault: json["is_default"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "full_name": fullName,
        "country": country,
        "city": city,
        "long_address": longAddress,
        "phone_number": phoneNumber,
        "map_lat": mapLat,
        "map_long": mapLong,
        "apartment": apartment,
        "building_name": buildingName,
        "floor": floor,
        "customer_id": customerId,
        "comment": comment,
        "address_type": addressType,
        "is_default": isDefault == null?false:isDefault,
      };

  @override
  String toString() {
    return 'DeliveryAddress{id: $id, fullName: $fullName, country: $country, city: $city, longAddress: $longAddress, phoneNumber: $phoneNumber, mapLat: $mapLat, mapLong: $mapLong, apartment: $apartment, buildingName: $buildingName, floor: $floor, customerId: $customerId, comment: $comment, addressType: $addressType, isDefault: $isDefault}';
  }
}