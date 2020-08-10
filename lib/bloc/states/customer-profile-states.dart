import 'dart:io';

import 'package:tienda/model/customer.dart';

abstract class CustomerProfileStates {
  CustomerProfileStates();
}

class Loading extends CustomerProfileStates {
  Loading() : super();
}

class OfflineLoadCustomerDataSuccess extends CustomerProfileStates {
  final Customer customerDetails;

  OfflineLoadCustomerDataSuccess({this.customerDetails}) : super();
}

class LoadCustomerProfileSuccess extends CustomerProfileStates {
  final Customer customerDetails;
  final File profileImage;

  LoadCustomerProfileSuccess({this.customerDetails, this.profileImage})
      : super();
}
class UpdateProfilePictureInProgress extends CustomerProfileStates {
  final Customer customerDetails;

  UpdateProfilePictureInProgress({this.customerDetails})
      : super();
}
