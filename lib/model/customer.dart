import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
part 'customer.g.dart';

@JsonSerializable()
class Customer {
  @JsonKey(name: "phone_number")
  String mobileNumber;

  @JsonKey(name: "dob")
  String dob;

  @JsonKey(name: "full_name")
  String name;

  @JsonKey(name: "email")
  String email;

  @JsonKey(name: "referral")
  String referral;

  @JsonKey(name: "country")
  String country;

  @JsonKey(name: "profile_picture")
  String profileImage;

  Customer();
  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  @override
  String toString() {
    return 'Customer{mobileNumber: $mobileNumber, dob: $dob, name: $name, email: $email, referral: $referral, country: $country, profileImage: $profileImage}';
  }
}
