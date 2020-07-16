import 'package:equatable/equatable.dart';
import 'package:tienda/model/customer.dart';

abstract class CustomerProfileStates extends Equatable {
  CustomerProfileStates();

  @override
  List<Object> get props => null;
}

class Loading extends CustomerProfileStates {
  Loading() : super();
}

class LoadCustomerProfileSuccess extends CustomerProfileStates {
  final Customer customerDetails;

  LoadCustomerProfileSuccess({this.customerDetails}) : super();

  @override
  List<Object> get props => [customerDetails];
}

class LoadCustomerProfileFail extends CustomerProfileStates {
  final dynamic error;

  LoadCustomerProfileFail(this.error) : super();

  @override
  List<Object> get props => error;
}

class EditCustomerProfileSuccess extends CustomerProfileStates {
  final Customer customer;
  EditCustomerProfileSuccess({this.customer}) : super();

  @override
  List<Object> get props => [];
}
