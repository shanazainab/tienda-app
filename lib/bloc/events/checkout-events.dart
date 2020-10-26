import 'package:tienda/model/delivery-address.dart';
import 'package:tienda/model/payment-card.dart';
import 'package:tienda/model/product.dart';

abstract class CheckoutEvents {

  CheckoutEvents();
}

class DoCartCheckoutProgressUpdate extends CheckoutEvents {
  final PaymentCard card;
  final bool fromLiveStream;
  final int presenterId;
  final DeliveryAddress deliveryAddress;
  final String checkOutStatus;
  final List<Product> products;

  DoCartCheckoutProgressUpdate(
      {this.deliveryAddress,
      this.checkOutStatus,
      this.card,
      this.products,
      this.fromLiveStream,
      this.presenterId})
      : super();
}

class InitializeLiveStreamCheckout extends CheckoutEvents{
  InitializeLiveStreamCheckout();
}
class UpdateLiveCheckout extends CheckoutEvents{
  final DeliveryAddress deliveryAddress;
  final PaymentCard card;
  UpdateLiveCheckout({this.deliveryAddress,this.card});
}