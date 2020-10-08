import 'package:tienda/model/order.dart';
import 'package:tienda/model/payment-card.dart';
import 'package:tienda/model/product.dart';

abstract class CheckoutEvents {
  CheckoutEvents();
}

class Initialize extends CheckoutEvents {
  Initialize() : super();
}

class DoCartCheckout extends CheckoutEvents {
  final Order order;
  final PaymentCard card;

  final int cardId;

  final int cvv;

  final bool fromLiveStream;
  final int presenterId;

  DoCartCheckout(
      {this.order,
      this.card,
      this.cardId,
      this.cvv,
      this.fromLiveStream,
      this.presenterId})
      : super();
}

class DoUpdateCheckOutProgress extends CheckoutEvents {
  final String status;
  final List<Product> products;
  final Order order;

  DoUpdateCheckOutProgress({this.order, this.status, this.products}) : super();
}
