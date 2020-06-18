import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/api/product-api-client.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/states/product-states.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/product.dart';

class ProductBloc extends Bloc<ProductEvents, ProductStates> {
  @override
  ProductStates get initialState => Loading();

  @override
  Stream<ProductStates> mapEventToState(ProductEvents event) async* {
    if (event is FetchProductList) {
      yield* _mapFetchProductListToStates(event);
    }
  }

  Stream<ProductStates> _mapFetchProductListToStates(
      FetchProductList event) async* {
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;

    List<Product> products = new List();

    ProductApiClient productApiClient = ProductApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await productApiClient.getDummyProducts().then((response) {
      print("#########");
      print("GET-PRODUCT-LIST-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          for (final product in json.decode(response)['products'])
            products.add(Product.fromJson(product));
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        print('%%%%%%%%%');
        print("GET-PRODUCT-LIST-ERROR:${error.response}");

        print("GET-PRODUCT-LIST-ERROR:${error.response?.data}");
        print('%%%%%REQUEST%%%%');

        print("GET-PRODUCT-LIST-ERROR:${error.request?.data}");
      }
    });

    if (products.isNotEmpty) yield LoadProductListSuccess(products);
  }
}
