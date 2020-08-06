import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:tienda/model/customer.dart';

abstract class CustomerProfileEvents extends Equatable {
  CustomerProfileEvents();

  @override
  List<Object> get props => null;
}

class UpdateProfilePicture extends CustomerProfileEvents {
  final Customer customer;
  final File profileImage;

  UpdateProfilePicture(this.customer,this.profileImage) : super();

  @override
  List<Object> get props => [profileImage];
}

class OfflineLoadCustomerData extends CustomerProfileEvents {
  OfflineLoadCustomerData() : super();

  @override
  List<Object> get props => [];
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
