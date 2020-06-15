import 'package:equatable/equatable.dart';
import 'package:tienda/model/customer.dart';
import 'package:tienda/model/login-request.dart';
import 'package:tienda/model/login-verify-request.dart';

abstract class LoginEvents extends Equatable {
  LoginEvents();

  @override
  List<Object> get props => null;
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
class CustomerRegister extends LoginEvents {
  final Customer customer;

  CustomerRegister({this.customer}) : super();

  @override
  List<Object> get props => [customer];
}