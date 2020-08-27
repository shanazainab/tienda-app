import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/product-api-client.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/states/product-states.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/product.dart';

class SingleProductBloc extends Bloc<ProductEvents, ProductStates> {
  SingleProductBloc() : super(Loading());



  @override
  Stream<ProductStates> mapEventToState(ProductEvents event) async* {
    if (event is FetchProductDetails) {
      yield* _mapFetchProductDetailsToStates(event);
    }
  }

  Stream<ProductStates> _mapFetchProductDetailsToStates(
      FetchProductDetails event) async* {
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;

    String status;
    Product product;

    ProductApiClient productApiClient = ProductApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await productApiClient
        .getProductDetailsByCategory(event.productId.toString())
        .then((response) {
      Logger().d("GET-PRODUCT-DETAILS-RESPONSE:$response");

      log("GET-PRODUCT-DETAILS-RESPONSE:$response");

      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          product = Product.fromJson(json.decode(response)['product']);
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET-PRODUCT-DETAILS-ERROR:", error);
      }
    });

    Logger().d("SINGLE PRODUCT DETAILS: $product");

    if (status == "success") yield FetchProductDetailsSuccess(product: product);
  }
}
