import 'package:equatable/equatable.dart';
import 'package:tienda/model/product-list-response.dart';
import 'package:tienda/model/product.dart';

abstract class ProductEvents extends Equatable {
  ProductEvents();

  @override
  List<Object> get props => null;
}

class FetchProductList extends ProductEvents {
  final String categoryId;
  final String pageNumber;

  FetchProductList({this.categoryId,this.pageNumber}) : super();

  @override
  List<Object> get props => [];
}

class FetchProductDetails extends ProductEvents {
  final int productId;

  FetchProductDetails({this.productId}) : super();

  @override
  List<Object> get props => [];
}

class FetchMoreProductList extends ProductEvents {
  final List<Product> products;
  final String categoryId;
  final String pageNumber;

  FetchMoreProductList({this.products,this.categoryId,this.pageNumber}) : super();

  @override
  List<Object> get props => [];
}


class UpdateMarkAsWishListed extends ProductEvents {
  final ProductListResponse productListResponse;

  UpdateMarkAsWishListed({this.productListResponse}) : super();

  @override
  List<Object> get props => [productListResponse];
}
