import 'package:json_annotation/json_annotation.dart';

part 'login-verify-request.g.dart';
@JsonSerializable()
class LoginVerifyRequest{


  @JsonKey(name: "phone_number")
  String mobileNumber;

  @JsonKey(name: "otp")
  String otp;

  LoginVerifyRequest({this.mobileNumber,this.otp});

  factory LoginVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginVerifyRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginVerifyRequestToJson(this);
}
