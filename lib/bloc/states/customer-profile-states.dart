import 'dart:io';

import 'package:tienda/model/customer.dart';
import 'package:tienda/model/watch-history.dart';

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

class NoCustomerData extends CustomerProfileStates {
  NoCustomerData() : super();
}

class LoadCustomerProfileSuccess extends CustomerProfileStates {
  final Customer customerDetails;
  final File profileImage;

  LoadCustomerProfileSuccess({this.customerDetails, this.profileImage})
      : super();
}

class UpdateProfilePictureInProgress extends CustomerProfileStates {
  final Customer customerDetails;

  UpdateProfilePictureInProgress({this.customerDetails}) : super();
}

class ChangePhoneNumberSuccess extends CustomerProfileStates {
  ChangePhoneNumberSuccess() : super();
}

class VerifyPhoneNumberSuccess extends CustomerProfileStates {
  VerifyPhoneNumberSuccess() : super();
}
class LoadWatchHistorySuccess extends CustomerProfileStates {

  List<WatchHistory> watchHistory;

  LoadWatchHistorySuccess(this.watchHistory) : super();
}