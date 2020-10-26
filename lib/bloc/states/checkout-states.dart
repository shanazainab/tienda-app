import 'package:tienda/model/delivery-address.dart';
import 'package:tienda/model/payment-card.dart';

abstract class CheckoutStates {
  CheckoutStates();
}

class Loading extends CheckoutStates {}

class DoCartCheckoutUpdateSuccess extends CheckoutStates {
  final DeliveryAddress deliveryAddress;
  final PaymentCard card;
  final bool fromLiveStream;
  final int presenterId;
  final String checkOutStatus;

  DoCartCheckoutUpdateSuccess(
      {this.presenterId,
      this.deliveryAddress,
      this.card,
      this.fromLiveStream,
      this.checkOutStatus})
      : super();
}

class LiveCheckoutInitializationComplete extends CheckoutStates{
  final DeliveryAddress deliveryAddress;
  final PaymentCard card;

  LiveCheckoutInitializationComplete({this.deliveryAddress, this.card});
}

class UpdateLiveCheckoutComplete extends CheckoutStates{
  final DeliveryAddress deliveryAddress;
  final PaymentCard card;

  UpdateLiveCheckoutComplete({this.deliveryAddress, this.card});
}