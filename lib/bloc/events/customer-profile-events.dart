import 'dart:io';
import 'package:tienda/model/customer.dart';

abstract class CustomerProfileEvents {
  CustomerProfileEvents();
}

class UpdateProfilePicture extends CustomerProfileEvents {
  final Customer customer;
  final File profileImage;

  UpdateProfilePicture(this.customer, this.profileImage) : super();
}

class OfflineLoadCustomerData extends CustomerProfileEvents {
  OfflineLoadCustomerData() : super();
}

class FetchCustomerProfile extends CustomerProfileEvents {
  FetchCustomerProfile() : super();
}

class EditCustomerProfile extends CustomerProfileEvents {
  final Customer customer;

  EditCustomerProfile({this.customer}) : super();
}
