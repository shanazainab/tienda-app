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

class ChangePhoneNumber extends CustomerProfileEvents {
  final String phoneNumber;

  ChangePhoneNumber({this.phoneNumber}) : super();
}
class VerifyPhoneNumber extends CustomerProfileEvents {
  final String phoneNumber;
  final String otp;

  VerifyPhoneNumber({this.phoneNumber,this.otp}) : super();
}
class ChangeEmail extends CustomerProfileEvents {
  final String phoneNumber;

  ChangeEmail({this.phoneNumber}) : super();
}
class VerifyEmail extends CustomerProfileEvents {
  final String phoneNumber;

  VerifyEmail({this.phoneNumber}) : super();
}