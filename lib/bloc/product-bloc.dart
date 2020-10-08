import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/search-api-client.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/states/product-states.dart';
import 'package:tienda/model/product-list-response.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/model/search-body.dart';

class ProductBloc extends Bloc<ProductEvents, ProductStates> {
  ProductBloc() : super(Loading());



  @override
  Stream<ProductStates> mapEventToState(ProductEvents event) async* {
    if (event is Initialize) {
      yield Loading();
    }
    if (event is FetchProductList) {
      yield* _mapFetchProductListToStates(event);
    }
    if (event is FetchFilteredProductList) {
      yield* _mapFetchFilteredProductListToStates(event);
    }
    if (event is UpdateMarkAsWishListed) {
      yield* _mapUpdateMarkAsWishListedToStates(event);
    }

    if (event is FetchMoreProductList) {
      yield* _mapFetchMoreProductListToStates(event);
    }
  }


  Stream<ProductStates> _mapFetchFilteredProductListToStates(
      FetchFilteredProductList event) async* {

    yield Loading();
    ProductListResponse productListResponse;

    productListResponse = await callProductSearchByQuery(
        event.query,"", event.searchBody);
    print("productListResponse:$productListResponse");
    if (productListResponse != null)
      yield UpdateProductListSuccess(productListResponse);
  }


  Future<ProductListResponse> callProductSearchByQuery(
      String query, String pageNumber, SearchBody searchBody) async {
    ProductListResponse productListResponse;

    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = SearchApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.searchProducts(query, pageNumber, searchBody).then((response) {

      switch (json.decode(response)['status']) {
        case 200:
          productListResponse =
              ProductListResponse.fromJson(json.decode(response));
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("PRODUCT-SEARCH-ERROR:", error.response.data);
      }
    });
    return productListResponse;
  }

  Stream<ProductStates> _mapUpdateMarkAsWishListedToStates(
      UpdateMarkAsWishListed event) async* {
    print(event.productListResponse);

    yield UpdateProductListSuccess(event.productListResponse);
  }

  Stream<ProductStates> _mapFetchProductListToStates(
      FetchProductList event) async* {
    yield Loading();

    ProductListResponse productListResponse;

    productListResponse = await callProductSearchByQuery(
        event.query, event.pageNumber, event.searchBody);
    log("FETCH PRODUCT RESPONSE:${productListResponse.products}");
    if (productListResponse != null)
      yield LoadProductListSuccess(productListResponse);
  }

  Stream<ProductStates> _mapFetchMoreProductListToStates(
      FetchMoreProductList event) async* {

    ProductListResponse productListResponse;

    productListResponse = await callProductSearchByQuery(
        event.query, event.pageNumber, event.searchBody);

    Logger().d("PRODUCT LIST RESPONSE:$productListResponse");

    List<Product> products = new List();

    products.addAll(event.products);

    products.addAll(productListResponse.products);

    productListResponse.products = products;
    yield LoadProductListSuccess(productListResponse);
  }
}
