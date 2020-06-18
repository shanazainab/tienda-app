import 'package:equatable/equatable.dart';

abstract class ProfileEvents extends Equatable {
  ProfileEvents();

  @override
  List<Object> get props => null;
}

class FetchCustomerProfile extends ProfileEvents {
  FetchCustomerProfile() : super();

  @override
  List<Object> get props => [];
}
