import 'package:tienda/model/payment-card.dart';

abstract class SavedCardEvents {
  SavedCardEvents();
}

class LoadSavedCards extends SavedCardEvents {
  LoadSavedCards() : super();
}

class AddSavedCards extends SavedCardEvents {
  PaymentCard paymentCard;

  AddSavedCards({this.paymentCard}) : super();
}

class DeleteSavedCard extends SavedCardEvents {
  int cardId;
  List<PaymentCard> paymentCards;

  DeleteSavedCard({this.paymentCards,this.cardId}) : super();
}
