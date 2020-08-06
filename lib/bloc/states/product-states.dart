import 'package:equatable/equatable.dart';
import 'package:tienda/model/product-list-response.dart';
import 'package:tienda/model/product.dart';

abstract class ProductStates {
  ProductStates();
}

class Loading extends ProductStates {
  Loading() : super();
}

class LoadProductListSuccess extends ProductStates {
  final ProductListResponse productListResponse;

  LoadProductListSuccess(this.productListResponse) : super();
}

class FetchProductDetailsSuccess extends ProductStates {
  final Product product;

  FetchProductDetailsSuccess({this.product}) : super();
}

class LoadProductListFail extends ProductStates {
  final dynamic error;

  LoadProductListFail(this.error) : super();
}

class UpdateProductListSuccess extends ProductStates {
  final ProductListResponse productListResponse;

  UpdateProductListSuccess(this.productListResponse) : super();

}
