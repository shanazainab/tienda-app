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
