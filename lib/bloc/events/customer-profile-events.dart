import 'package:equatable/equatable.dart';

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
