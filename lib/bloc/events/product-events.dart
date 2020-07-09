import 'package:equatable/equatable.dart';
import 'package:tienda/model/product.dart';

abstract class ProductEvents extends Equatable {
  ProductEvents();

  @override
  List<Object> get props => null;
}

class FetchProductList extends ProductEvents {
  FetchProductList() : super();

  @override
  List<Object> get props => [];
}

class UpdateMarkAsWishListed extends ProductEvents {
  final List<Product> products;

  UpdateMarkAsWishListed({this.products}) : super();

  @override
  List<Object> get props => [products];
}
