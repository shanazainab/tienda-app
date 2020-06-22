import 'package:json_annotation/json_annotation.dart';
part 'login-request.g.dart';

@JsonSerializable()
class LoginRequest {
  @JsonKey(name: "phone_number")
  String mobileNumber;

  LoginRequest({this.mobileNumber});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
