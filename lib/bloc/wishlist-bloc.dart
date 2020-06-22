import 'dart:convert';

import 'package:ansicolor/ansicolor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/api/wishlist-api-client.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/wishlist-states.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/model/wishlist.dart';

class WishListBloc extends Bloc<WishListEvents, WishListStates> {
  final FlutterSecureStorage _secureStorage = new FlutterSecureStorage();

  @override
  WishListStates get initialState => Loading();

  @override
  Stream<WishListStates> mapEventToState(WishListEvents event) async* {
    if (event is LoadWishListProducts) {
      yield* _mapLoadWishListProductsToStates(event);
    }
    if (event is AddToWishList) {
      yield* _mapAddWishListToStates(event);
    }
    if (event is DeleteWishListItem) {
      yield* _mapDeleteWishListItemToStates(event);
    }
  }

  Stream<WishListStates> _mapAddWishListToStates(AddToWishList event) async* {
    final dio = Dio();
    String status;
    String value = await _secureStorage.read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = WishListApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.addToWishList(event.wishListItem.product.id).then((response) {
      AnsiPen pen = new AnsiPen()..green();
      print(pen("ADD-TO-WISH-LIST-RESPONSE:$response"));
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          break;
        case 407:
          status = "Enter Valid Number";
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        AnsiPen pen = new AnsiPen()..green();
        print(pen("ADD-TO-WISH-LIST-ERROR:${error.response}"));
        print(pen("ADD-TO-WISH-LIST-ERROR-DATA:${error.response?.data}"));
        print(pen("ADD-TO-WISH-LIST-ERROR-REQUEST:${error.request?.data}"));
      }
    });
    if (status == "success") yield DeleteWishListItemSuccess();
  }

  Stream<WishListStates> _mapDeleteWishListItemToStates(
      DeleteWishListItem event) async* {
    final dio = Dio();
    String status;
    String value = await _secureStorage.read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = WishListApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client
        .deleteFromWishList(event.wishListItem.product.id)
        .then((response) {
      AnsiPen pen = new AnsiPen()..green();
      print(pen("DELETE-FROM-WISH-LIST-RESPONSE:$response"));
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          break;
        case 400:
          status = "Enter Valid Number";
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        AnsiPen pen = new AnsiPen()..green();
        print(pen("DELETE-FROM-WISH-LIST-ERROR:${error.response}"));
        print(pen("DELETE-FROM-WISH-LIST-ERROR-DATA:${error.response?.data}"));
        print(
            pen("DELETE-FROM-WISH-LIST-ERROR-REQUEST:${error.request?.data}"));
      }
    });
    if (status == "success") yield DeleteWishListItemSuccess();
  }

  Stream<WishListStates> _mapLoadWishListProductsToStates(
      LoadWishListProducts event) async* {
    String status;
    WishList wishList = new WishList(wishListItems: new List());
    final dio = Dio();
    String value = await _secureStorage.read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = WishListApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.fetchWishList().then((response) {
      AnsiPen pen = new AnsiPen()..green();
      print(pen("FETCH-WISH-LIST-RESPONSE:$response"));
      switch (json.decode(response)['status']) {
        case 200:
          if (json.decode(response)['wishlist'].isNotEmpty) {
            status = "success";
            for (final item in json.decode(response)['wishlist']) {
              wishList.wishListItems
                  .add(new WishListItem(product: Product.fromJson(item)));
            }
          } else
            status = "empty";
          break;
        case 400:
          status = 'failed';
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        AnsiPen pen = new AnsiPen()..green();
        print(pen("FETCH-WISH-LIST-ERROR:${error.response}"));
        print(pen("FETCH-WISH-LIST-ERROR-DATA:${error.response?.data}"));
        print(pen("FETCH-WISH-LIST-ERROR-REQUEST:${error.request?.data}"));
      }
    });

    if (status == "success") yield LoadWishListSuccess(wishList: wishList);
  }
}
