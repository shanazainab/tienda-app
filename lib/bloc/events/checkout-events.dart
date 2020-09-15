import 'package:equatable/equatable.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/model/payment-card.dart';

abstract class CheckoutEvents {
  CheckoutEvents();
}

class Initialize extends CheckoutEvents {
  Initialize() : super();
}

class DoCartCheckout extends CheckoutEvents {
  final int addressId;
  final PaymentCard card;

  final int cardId;

  final int cvv;

  DoCartCheckout({this.addressId, this.card, this.cardId, this.cvv}) : super();
}

class DoUpdateCheckOutProgress extends CheckoutEvents {
  final Order order;
  final String status;

  DoUpdateCheckOutProgress({this.status, this.order}) : super();
}
