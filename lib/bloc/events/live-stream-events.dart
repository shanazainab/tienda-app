import 'package:tienda/model/product.dart';

abstract class LiveStreamEvents {
  LiveStreamEvents();
}

class InitializeSocket extends LiveStreamEvents {
  final int presenterId;

  InitializeSocket(this.presenterId) : super();
}

class MessageSend extends LiveStreamEvents {
  final int presenterId;

  MessageSend(
    this.presenterId,
  ) : super();
}

class JoinLive extends LiveStreamEvents {
  final int presenterId;

  JoinLive(
    this.presenterId,
  ) : super();
}

class ShowProduct extends LiveStreamEvents {
  final Product product;

  ShowProduct(
    this.product,
  ) : super();
}

class UpdateWishListProducts extends LiveStreamEvents {
  final List<Product> products;

  UpdateWishListProducts(
    this.products,
  ) : super();
}
