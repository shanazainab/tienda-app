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
import 'package:tienda/controller/login-controller.dart';
import 'package:tienda/model/cart.dart';

class CartBloc extends Bloc<CartEvents, CartStates> {
  @override
  CartStates get initialState => Initialized();

  @override
  Stream<CartStates> mapEventToState(CartEvents event) async* {
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
  }

  Stream<CartStates> _mapFetchCartToStates(FetchCartData event) async* {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey("cart")) {
      Cart cart =
          Cart.fromJson(json.decode(sharedPreferences.getString('cart')));
      yield LoadCartSuccess(cart: cart);
    } else {
      yield EmptyCart();
    }
  }

  Stream<CartStates> _mapAddCartItemToStates(AddCartItem event) async* {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Cart cart;
    if (sharedPreferences.containsKey("cart")) {
      ///Items exist in cart
      cart = Cart.fromJson(json.decode(sharedPreferences.getString('cart')));

      if (!cart.cartItems.contains(event.cartItem)) {
        cart.cartItems.add(event.cartItem);

        CartPrice existingPrice = cart.cartPrice;
        print("EXISTING CART :$existingPrice");
        CartPrice newCartPrice = new CartPrice(
          discountTotal: existingPrice.discountTotal + 0,
          cartTotal: existingPrice.cartTotal + event.cartItem.product.price,
          deliverCharge: 0.0,
        );
        cart.cartPrice = newCartPrice;

        sharedPreferences.setString("cart", json.encode(cart.toJson()));
      }
    } else {
      ///first cart item
      cart = new Cart(
        cartItems: [event.cartItem],
        cartPrice: new CartPrice(
          discountTotal: 0,
          cartTotal: event.cartItem.product.price,
          deliverCharge: 0.0,
        ),
      );

      sharedPreferences.setString("cart", json.encode(cart.toJson()));
    }
    yield AddToCartSuccess(addedCart: cart);

    ///LoggedIn User call the cart API
    bool isLoggedIn = await new LoginController().checkLoginStatus();
    if (isLoggedIn) {
      ///Update cart to backend
      callAddCartApi(event.cartItem);
    }
  }

  Stream<CartStates> _mapEditCartItemToStates(EditCartItem event) async* {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Cart cart = Cart.fromJson(json.decode(sharedPreferences.getString('cart')));

    for (int index = 0; index < cart.cartItems.length; ++index) {
      if (cart.cartItems[index] == event.cartItem) {
        cart.cartItems[index] = event.cartItem;
      }
    }
    sharedPreferences.setString("cart", json.encode(cart.toJson()));
    yield EditCartItemSuccess();

    ///LoggedIn User call the cart API
    ///TODO: EDIT CART BACKEND API
//    bool isLoggedIn = await new LoginController().checkLoginStatus();
//    if (isLoggedIn) {
//      ///Update cart to backend
//      callAddCartApi(event.cartItem);
//    }
  }

  Stream<CartStates> _mapDeleteCartItemToStates(DeleteCartItem event) async* {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Cart cart = Cart.fromJson(json.decode(sharedPreferences.getString('cart')));

    cart.cartItems.removeWhere((item) => item == event.cartItem);
    sharedPreferences.setString("cart", json.encode(cart.toJson()));
    yield DeleteCartItemSuccess(cart: cart);
    yield LoadCartSuccess(cart: cart);

    ///LoggedIn User call the cart API
    bool isLoggedIn = await new LoginController().checkLoginStatus();
    if (isLoggedIn) {
      ///delete cart item to backend
      callDeleteCartAPI(event.cartItem);
    }
  }

  callAddCartApi(CartItem cartItem) async {
    String status;

    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client =
        CartApiClient(dio, baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.addToCart(cartItem.product.id).then((response) {
      Logger().d("ADD-CART-RESPONSE:$response");
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
        Logger().e("ADD-CART-ERROR:", error);
      }
    });

    return status;
  }

  callDeleteCartAPI(CartItem cartItem) async {
    String status;

    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client =
        CartApiClient(dio, baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.deleteFromCart(cartItem.product.id).then((response) {
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
}
