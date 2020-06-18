import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

      ///check login status
      ///call cart apis if they are logged in

      bool isLoggedIn = await new LoginController().checkLoginStatus();
      if(isLoggedIn){

      }



    } else {
      yield EmptyCart();
    }
  }

  _mapEditCartItemToStates(EditCartItem event) {

  }

  _mapDeleteCartItemToStates(DeleteCartItem event) {}
}
