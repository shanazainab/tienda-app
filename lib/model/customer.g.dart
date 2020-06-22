// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer()
    ..mobileNumber = json['phone_number'] as String
    ..dob = json['dob'] as String
    ..name = json['full_name'] as String
    ..email = json['email'] as String
    ..referral = json['referral'] as String;
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'phone_number': instance.mobileNumber,
      'dob': instance.dob,
      'full_name': instance.name,
      'email': instance.email,
      'referral': instance.referral,
    };
