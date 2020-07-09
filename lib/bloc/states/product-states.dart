import 'package:equatable/equatable.dart';
import 'package:tienda/model/product.dart';

abstract class ProductStates {
  ProductStates();


}

class Loading extends ProductStates {
  Loading() : super();
}

class LoadProductListSuccess extends ProductStates {
  final List<Product> products;

  LoadProductListSuccess(this.products) : super();


}

class LoadProductListFail extends ProductStates {
  final dynamic error;

  LoadProductListFail(this.error) : super();


}
class UpdateProductListSuccess extends ProductStates {
  final List<Product> products;

  UpdateProductListSuccess(this.products) : super();

  @override
  bool operator ==(Object other) =>
      false;

  @override
  int get hashCode => products.hashCode;
}


