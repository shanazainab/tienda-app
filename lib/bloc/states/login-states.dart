import 'package:equatable/equatable.dart';

abstract class LoginStates extends Equatable {
  LoginStates();

  @override
  List<Object> get props => null;
}

class LoginInitiated extends LoginStates {
  LoginInitiated() : super();
}

class LoginInProgress extends LoginStates {
  LoginInProgress() : super();

  @override
  List<Object> get props => null;
}

class LoginSendOTPSuccess extends LoginStates {
  final dynamic response;

  LoginSendOTPSuccess(this.response) : super();

  @override
  List<Object> get props => response;
}

class LoginSendOTPError extends LoginStates {
  final dynamic error;

  LoginSendOTPError({this.error}) : super();

  @override
  List<Object> get props => error;
}

class LoginVerifyOTPSuccess extends LoginStates {
  final bool isNewUser;

  LoginVerifyOTPSuccess({this.isNewUser}) : super();

  @override
  List<Object> get props => [isNewUser];
}

class LoginVerifyOTPError extends LoginStates {
  final String error;

  LoginVerifyOTPError({this.error}) : super();

  @override
  List<Object> get props => [error];
}

class GoogleSignInResponse extends LoginStates {
  static const int SUCCESS = 0;
  static const int CANCELLED = 1;
  static const int FAILED = 2;

  final int response;

  GoogleSignInResponse({this.response}) : super();

  @override
  List<Object> get props => [response];
}

class FacebookSignInResponse extends LoginStates {
  static const int SUCCESS = 0;
  static const int CANCELLED = 1;
  static const int FAILED = 2;

  final int response;

  FacebookSignInResponse({this.response}) : super();

  @override
  List<Object> get props => [response];
}

class CustomerRegistrationInProgress extends LoginStates {
  CustomerRegistrationInProgress() : super();

  @override
  List<Object> get props => null;
}

class CustomerRegistrationSuccess extends LoginStates {
  CustomerRegistrationSuccess() : super();

  @override
  List<Object> get props => null;
}

class LogoutSuccess extends LoginStates {
  LogoutSuccess() : super();

  @override
  List<Object> get props => [];
}

class LogoutError extends LoginStates {
  final String error;

  LogoutError({this.error}) : super();

  @override
  List<Object> get props => [error];
}
