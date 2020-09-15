import 'package:equatable/equatable.dart';
import 'package:tienda/model/payment-card.dart';
import 'package:tienda/model/delivery-address.dart';

abstract class SavedCardStates {
  SavedCardStates();
}

class Loading extends SavedCardStates {
  Loading() : super();
}

class LoadSavedCardSuccess extends SavedCardStates {
  final List<PaymentCard> paymentCards;

  LoadSavedCardSuccess({this.paymentCards}) : super();
}

class EditSavedCardSuccess extends SavedCardStates {
  EditSavedCardSuccess() : super();
}

class DeleteSavedCardSuccess extends SavedCardStates {
  DeleteSavedCardSuccess() : super();
}

class AuthorizationFailed extends SavedCardStates {
  AuthorizationFailed() : super();
}

class SavedCardEmpty extends SavedCardStates {
  SavedCardEmpty() : super();
}
