abstract class LoginStates {
  LoginStates();
}

class LoginInitiated extends LoginStates {
  LoginInitiated() : super();
}

class LoginInProgress extends LoginStates {
  LoginInProgress() : super();
}

class LoginSendOTPSuccess extends LoginStates {
  final dynamic response;

  LoginSendOTPSuccess(this.response) : super();
}

class LoginSendOTPError extends LoginStates {
  final dynamic error;

  LoginSendOTPError({this.error}) : super();
}

class LoginVerifyOTPSuccess extends LoginStates {
  final bool isNewUser;

  LoginVerifyOTPSuccess({this.isNewUser}) : super();
}

class LoginVerifyOTPError extends LoginStates {
  final String error;

  LoginVerifyOTPError({this.error}) : super();
}

class GoogleSignInResponse extends LoginStates {
  static const int SUCCESS = 0;
  static const int CANCELLED = 1;
  static const int FAILED = 2;

  final int response;

  GoogleSignInResponse({this.response}) : super();
}

class FacebookSignInResponse extends LoginStates {
  static const int SUCCESS = 0;
  static const int CANCELLED = 1;
  static const int FAILED = 2;

  final int response;

  FacebookSignInResponse({this.response}) : super();
}

class CustomerRegistrationInProgress extends LoginStates {
  CustomerRegistrationInProgress() : super();
}

class CustomerRegistrationSuccess extends LoginStates {
  CustomerRegistrationSuccess() : super();
}

class LogoutSuccess extends LoginStates {
  LogoutSuccess() : super();
}

class LogoutError extends LoginStates {
  final String error;

  LogoutError({this.error}) : super();
}

class LoggedInUser extends LoginStates {
  LoggedInUser() : super();
}

class GuestUser extends LoginStates {
  GuestUser() : super();
}
