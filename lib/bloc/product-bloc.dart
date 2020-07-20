import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/product-api-client.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/states/product-states.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/product-list-response.dart';
import 'package:tienda/model/product.dart';

class ProductBloc extends Bloc<ProductEvents, ProductStates> {
  @override
  ProductStates get initialState => Loading();

  @override
  Stream<ProductStates> mapEventToState(ProductEvents event) async* {
    if (event is FetchProductList) {
      yield* _mapFetchProductListToStates(event);
    }
    if (event is UpdateMarkAsWishListed) {
      yield* _mapUpdateMarkAsWishListedToStates(event);
    }

    if (event is FetchMoreProductList) {
      yield* _mapFetchMoreProductListToStates(event);
    }
  }

  Stream<ProductStates> _mapUpdateMarkAsWishListedToStates(
      UpdateMarkAsWishListed event) async* {
    print(event.productListResponse);

    yield UpdateProductListSuccess(event.productListResponse);
  }

  Stream<ProductStates> _mapFetchProductListToStates(
      FetchProductList event) async* {
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;

    String status;

    ProductListResponse productListResponse;

    ProductApiClient productApiClient = ProductApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await productApiClient
        .getProductsByCategory(event.categoryId, event.pageNumber)
        .then((response) {
      Logger().d("GET-PRODUCT-LIST-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          productListResponse =
              ProductListResponse.fromJson(json.decode(response));
          status = "success";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET-PRODUCT-LIST-ERROR:", error);
      }
    });

    Logger().d("PRODUCT LIST RESPONSE:$productListResponse");

    if (status == "success") yield LoadProductListSuccess(productListResponse);
  }

  Stream<ProductStates> _mapFetchMoreProductListToStates(
      FetchMoreProductList event) async* {
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;

    String status;

    ProductListResponse productListResponse;

    ProductApiClient productApiClient = ProductApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await productApiClient
        .getProductsByCategory(event.categoryId, event.pageNumber)
        .then((response) {
      Logger().d("GET-PRODUCT-LIST-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          productListResponse =
              ProductListResponse.fromJson(json.decode(response));
          status = "success";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET-PRODUCT-LIST-ERROR:", error);
      }
    });

    Logger().d("PRODUCT LIST RESPONSE:$productListResponse");

    List<Product> products = new List();

    products.addAll(event.products);

    products.addAll(productListResponse.products);

    productListResponse.products = products;
    if (status == "success") yield LoadProductListSuccess(productListResponse);
  }
}
