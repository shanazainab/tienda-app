import 'package:equatable/equatable.dart';
import 'package:tienda/model/customer.dart';

abstract class ProfileStates extends Equatable {
  ProfileStates();

  @override
  List<Object> get props => null;
}

class Loading extends ProfileStates {
  Loading() : super();
}

class LoadCustomerProfileSuccess extends ProfileStates {
  final Customer customerDetails;

  LoadCustomerProfileSuccess({this.customerDetails}) : super();

  @override
  List<Object> get props => [customerDetails];
}

class LoadCustomerProfileFail extends ProfileStates {
  final dynamic error;

  LoadCustomerProfileFail(this.error) : super();

  @override
  List<Object> get props => error;
}
