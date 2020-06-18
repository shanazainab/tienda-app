import 'package:equatable/equatable.dart';
import 'package:tienda/model/product.dart';

abstract class ProductStates extends Equatable {
  ProductStates();

  @override
  List<Object> get props => null;
}

class Loading extends ProductStates {
  Loading() : super();
}

class LoadProductListSuccess extends ProductStates {
  final List<Product> products;

  LoadProductListSuccess(this.products) : super();

  @override
  List<Object> get props => [products];
}

class LoadProductListFail extends ProductStates {
  final dynamic error;

  LoadProductListFail(this.error) : super();

  @override
  List<Object> get props => error;
}
