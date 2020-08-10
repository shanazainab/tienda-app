import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/api/wishlist-api-client.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
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
    if (event is OfflineLoadWishList) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      WishList wishList = WishList.fromJson(
          json.decode(sharedPreferences.getString('wishlist')));
      yield LoadWishListSuccess(wishList: wishList);
    }
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
      Logger().d("ADD-TO-WISH-LIST-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          break;
        case 401:
          status = "Not Authorized";
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("ADD-TO-WISH-LIST-ERROR:${error.response}");
        Logger().e("ADD-TO-WISH-LIST-ERROR-DATA:${error.response?.data}");
        Logger().e("ADD-TO-WISH-LIST-ERROR-REQUEST:${error.request?.data}");
      }
    });
    if (status == "success") yield AddWishListSuccess();
    if (status == "Not Authorized") yield AuthorizationFailed();
  }

  Stream<WishListStates> _mapDeleteWishListItemToStates(
      DeleteWishListItem event) async* {
    if (event.wishList != null) {
      event.wishList.wishListItems.removeWhere((element) => element.product.id == event.wishListItem.product.id);
      print(event.wishList);

      if(event.wishList.wishListItems.isEmpty)
        yield EmptyWishList();
      else yield DeleteWishListItemSuccess(wishList: event.wishList);
    }

    final dio = Dio();
    String status;
    String value = await _secureStorage.read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = WishListApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client
        .deleteFromWishList(event.wishListItem.product.id)
        .then((response) {
      Logger().d("DELETE-FROM-WISH-LIST-RESPONSE:$response");
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
        Logger().d("DELETE-FROM-WISH-LIST-ERROR:${error.response}");
        Logger().d("DELETE-FROM-WISH-LIST-ERROR-DATA:${error.response?.data}");
        Logger()
            .d("DELETE-FROM-WISH-LIST-ERROR-REQUEST:${error.request?.data}");
      }
    });
  }

  Stream<WishListStates> _mapLoadWishListProductsToStates(
      LoadWishListProducts event) async* {
    yield Loading();
    String status;
    WishList wishList = new WishList(wishListItems: new List());
    final dio = Dio();
    String value = await _secureStorage.read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = WishListApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.fetchWishList().then((response) {
      Logger().d("FETCH-WISH-LIST-RESPONSE:$response");
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
        case 401:
          status = 'Not Authorized';
          break;
        default:
          status = 'failed';
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("FETCH-WISH-LIST-ERROR:${error.response}");
        Logger().e("FETCH-WISH-LIST-ERROR-DATA:${error.response?.data}");
        Logger().e("FETCH-WISH-LIST-ERROR-REQUEST:${error.request?.data}");
      }
    });

    if (wishList.wishListItems.isNotEmpty) updateWisListLocally(wishList);
    if(status == "empty") yield EmptyWishList();
    if (status == "success") yield LoadWishListSuccess(wishList: wishList);
    if (status == "Not Authorized") yield AuthorizationFailed();
  }

  Future<void> updateWisListLocally(WishList wishList) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("wishlist", json.encode(wishList));
    print(sharedPreferences.getString("wishlist"));
  }
}
