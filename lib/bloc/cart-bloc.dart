import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/api/cart-api-client.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/model/cart.dart';
import 'package:tienda/model/product.dart';

class CartBloc extends Bloc<CartEvents, CartStates> {
  CartBloc() : super(Initialized());


  @override
  Stream<CartStates> mapEventToState(CartEvents event) async* {
    if (event is OfflineLoadCart) {
      Cart cart = await getCartLocally();
      yield LoadCartSuccess(cart: cart);
    }
    if (event is FetchCartData) {
      yield* _mapFetchCartToStates(event);
    }
    if (event is AddCartItem) {
      yield* _mapAddCartItemToStates(event);
    }
    if (event is EditCartItem) {
      yield* _mapEditCartItemToStates(event);
    }
    if (event is DeleteCartItem) {
      yield* _mapDeleteCartItemToStates(event);
    }
    if (event is ClearCart) {
      yield* _mapEmptyCartToStates(event);
    }
  }

  Stream<CartStates> _mapEmptyCartToStates(ClearCart event) async* {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("cart");
    yield EmptyCart();
  }

  Stream<CartStates> _mapFetchCartToStates(FetchCartData event) async* {
    Cart cart = await callFetchCartApi();

    if (cart != null) {
      if (cart.products.isEmpty) {
        cart = null;
        yield EmptyCart();
      } else {
        double cartPrice = 0.0;
        for (final product in cart.products) {
          cartPrice += product.price;
        }
        cart.cartPrice = cartPrice;

        yield LoadCartSuccess(cart: cart);
      }
      updateCartLocally(cart);
    }
  }

  callFetchCartApi() async {
    Cart cart;
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client =
        CartApiClient(dio, baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.getCart().then((response) {
      Logger().d("GET-CART-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          cart = cartFromJson(response);
          break;

      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET-CART-ERROR:", error);
      }
    });
    return cart;
  }

  updateCartLocally(Cart cart) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("cart", json.encode(cart));
  }

  getCartLocally() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Cart cart;
    if (sharedPreferences.containsKey('cart')) {
      cart = cartFromJson(sharedPreferences.getString('cart'));
    }
    return cart;
  }

  Stream<CartStates> _mapAddCartItemToStates(AddCartItem event) async* {
    ///LoggedIn User call the cart API

    Logger().d("LOGGED IN STATUS: ${event.isLoggedIn}");
    bool isLoggedIn = event.isLoggedIn;

    String addCartStatus;

    if (isLoggedIn) {
      ///Update cart to backend
      addCartStatus = await callAddCartApi(event.cartItem);
    }

    if(event.isFromLiveStream && addCartStatus == "success"){
      new RealTimeController()
          .emitAddToCartFromLive(event.cartItem.id, event.presenterId);
    }


      Cart cart = await callFetchCartApi();
      if (cart != null) {
        double cartPrice = 0.0;
        for (final product in cart.products) {
          cartPrice += product.quantity != null && product.quantity != 0
              ? product.price * product.quantity
              : product.price;
        }
        cart.cartPrice = cartPrice;

        yield LoadCartSuccess(cart: cart);

        updateCartLocally(cart);

    }
  }

  Stream<CartStates> _mapEditCartItemToStates(EditCartItem event) async* {
    ///LoggedIn User call the cart API
    // bool isLoggedIn = await new LoginController().checkLoginStatus();
    bool isLoggedIn = event.isLoggedIn;
    if (isLoggedIn) {
      ///Update cart to backend
      await callChangeQuantity(event.cartItem);
    }
    Cart cart = await callFetchCartApi();
    if (cart != null) {
      double cartPrice = 0.0;
      for (final product in cart.products) {
        cartPrice += product.quantity != null && product.quantity != 0
            ? product.price * product.quantity
            : product.price;
      }
      cart.cartPrice = cartPrice;

      yield LoadCartSuccess(cart: cart);

      updateCartLocally(cart);
    }
  }

  Stream<CartStates> _mapDeleteCartItemToStates(DeleteCartItem event) async* {
    ///LoggedIn User call the cart API
    // bool isLoggedIn = await new LoginController().checkLoginStatus();
    bool isLoggedIn = event.isLoggedIn;
    if (isLoggedIn) {
      ///delete cart item to backend
      await callDeleteCartAPI(event.cartItem);
    }
    Cart cart = await callFetchCartApi();
    // flutter: │ 🐛 GET-CART-RESPONSE:{"status": 200, "cart": [], "summary": {"total_price": 0, "number_of_items": 0, "cart_status": "empty"}}

    if (cart.products.isEmpty) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.remove('cart');
      cart = null;
      yield EmptyCart();
    } else {
      double cartPrice = 0.0;
      for (final product in cart.products) {
        cartPrice += product.quantity != null && product.quantity != 0
            ? product.price * product.quantity
            : product.price;
      }
      cart.cartPrice = cartPrice;

      yield LoadCartSuccess(cart: cart);
    }

    updateCartLocally(cart);
  }

  callAddCartApi(Product cartItem) async {
    String status;

    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client =
        CartApiClient(dio, baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.addToCart(cartItem.id, cartItem.quantity).then((response) {
      Logger().d("ADD-CART-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          break;
        case 208:
        status ="duplicate";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("ADD-CART-ERROR:", error);
        Logger().e("ADD-CART-ERROR:", error.request.data);

      }
    });

    return status;
  }

  callDeleteCartAPI(Product cartItem) async {
    String status;

    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client =
        CartApiClient(dio, baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.deleteFromCart(cartItem.id).then((response) {
      Logger().d("DELETE-CART-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          break;
        case 407:
          status = "error";
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("DELETE-CART-ERROR:", error);
      }
    });

    return status;
  }

  callChangeQuantity(Product cartItem) async {
    String status;

    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client =
        CartApiClient(dio, baseUrl: GlobalConfiguration().getString("baseURL"));
    await client
        .changeQuantity(cartItem.id, cartItem.quantity)
        .then((response) {
      Logger().d("EDIT-CART-RESPONSE:$response");
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
        Logger().e("err: ${error.response.data}");
      }
    });

    return status;
  }
}
