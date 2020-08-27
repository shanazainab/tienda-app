import 'package:tienda/model/customer.dart';
import 'package:tienda/model/login-request.dart';
import 'package:tienda/model/login-verify-request.dart';

abstract class LoginEvents {
  LoginEvents();
}

class CheckLoginStatus extends LoginEvents {
  CheckLoginStatus() : super();
}

class SendOTP extends LoginEvents {
  final LoginRequest loginRequest;

  SendOTP({this.loginRequest}) : super();
}

class VerifyOTP extends LoginEvents {
  final LoginVerifyRequest loginVerifyRequest;

  VerifyOTP({this.loginVerifyRequest}) : super();
}

class DoGoogleSignIn extends LoginEvents {
  DoGoogleSignIn() : super();
}

class DoFacebookSignIn extends LoginEvents {
  DoFacebookSignIn() : super();
}

class RegisterCustomer extends LoginEvents {
  final Customer customer;

  RegisterCustomer({this.customer}) : super();
}

class Logout extends LoginEvents {
  Logout() : super();
}
