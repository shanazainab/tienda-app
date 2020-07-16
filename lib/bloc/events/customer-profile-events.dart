import 'package:equatable/equatable.dart';
import 'package:tienda/model/customer.dart';

abstract class CustomerProfileEvents extends Equatable {
  CustomerProfileEvents();

  @override
  List<Object> get props => null;
}

class FetchCustomerProfile extends CustomerProfileEvents {
  FetchCustomerProfile() : super();

  @override
  List<Object> get props => [];
}
class EditCustomerProfile extends CustomerProfileEvents {

  final Customer customer;
  EditCustomerProfile({this.customer}) : super();

  @override
  List<Object> get props => [];
}