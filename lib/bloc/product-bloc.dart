import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
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
    if (event is UpdateMarkAsWishListed) {
      yield* _mapUpdateMarkAsWishListedToStates(event);
    }
  }

  Stream<ProductStates> _mapUpdateMarkAsWishListedToStates(
      UpdateMarkAsWishListed event) async* {
    print(event.products);

    yield UpdateProductListSuccess(event.products);
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
      Logger().d("GET-PRODUCT-LIST-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          for (final product in json.decode(response)['products'])
            products.add(Product.fromJson(product));
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET-PRODUCT-LIST-ERROR:", error);
      }
    });

    print("777777777");
    print(products);

    print("777777777");

    if (products.isNotEmpty) yield LoadProductListSuccess(products);



  }
}
