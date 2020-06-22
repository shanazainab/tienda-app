// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login-verify-request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginVerifyRequest _$LoginVerifyRequestFromJson(Map<String, dynamic> json) {
  return LoginVerifyRequest(
    mobileNumber: json['phone_number'] as String,
    otp: json['otp'] as String,
  );
}

Map<String, dynamic> _$LoginVerifyRequestToJson(LoginVerifyRequest instance) =>
    <String, dynamic>{
      'phone_number': instance.mobileNumber,
      'otp': instance.otp,
    };
