import 'package:tienda/model/product-list-response.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/model/search-body.dart';

abstract class ProductEvents {
  ProductEvents();
}

class Initialize extends ProductEvents {
  Initialize() : super();
}

class FetchProductList extends ProductEvents {
  final String query;
  final String pageNumber;
  final SearchBody searchBody;

  FetchProductList({this.query, this.pageNumber, this.searchBody}) : super();
}

class FetchFilteredProductList extends ProductEvents {
  final String query;
  final SearchBody searchBody;

  FetchFilteredProductList({this.query, this.searchBody}) : super();
}

class FetchMoreProductList extends ProductEvents {
  final List<Product> products;
  final String query;
  final String pageNumber;
  final SearchBody searchBody;

  FetchMoreProductList(
      {this.products, this.query, this.pageNumber, this.searchBody})
      : super();
}

class FetchProductDetails extends ProductEvents {
  final int productId;

  FetchProductDetails({this.productId}) : super();
}

class UpdateMarkAsWishListed extends ProductEvents {
  final ProductListResponse productListResponse;

  UpdateMarkAsWishListed({this.productListResponse}) : super();
}
