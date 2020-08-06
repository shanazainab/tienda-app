import 'package:equatable/equatable.dart';
import 'package:tienda/model/customer.dart';
import 'package:tienda/model/login-request.dart';
import 'package:tienda/model/login-verify-request.dart';

abstract class LoginEvents extends Equatable {
  LoginEvents();

  @override
  List<Object> get props => null;
}

class CheckLoginStatus extends LoginEvents {
  CheckLoginStatus() : super();

  @override
  List<Object> get props => [];
}

class SendOTP extends LoginEvents {
  final LoginRequest loginRequest;

  SendOTP({this.loginRequest}) : super();

  @override
  List<Object> get props => [loginRequest];
}

class VerifyOTP extends LoginEvents {
  final LoginVerifyRequest loginVerifyRequest;

  VerifyOTP({this.loginVerifyRequest}) : super();

  @override
  List<Object> get props => [loginVerifyRequest];
}

class DoGoogleSignIn extends LoginEvents {
  DoGoogleSignIn() : super();

  @override
  List<Object> get props => [];
}

class DoFacebookSignIn extends LoginEvents {
  DoFacebookSignIn() : super();

  @override
  List<Object> get props => [];
}

class RegisterCustomer extends LoginEvents {
  final Customer customer;

  RegisterCustomer({this.customer}) : super();

  @override
  List<Object> get props => [customer];
}

class Logout extends LoginEvents {
  Logout() : super();

  @override
  List<Object> get props => [];
}
