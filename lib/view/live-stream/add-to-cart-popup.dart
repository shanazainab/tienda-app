import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/events/loading-events.dart';
import 'package:tienda/bloc/live-stream-checkout-bloc.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/live-stream-states.dart';
import 'package:tienda/bloc/states/loading-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/localization.dart';
import 'package:transparent_image/transparent_image.dart';

typedef AddedToCart = Function(bool value);

class AddToCartPopUp extends StatelessWidget {
  final BuildContext contextA;

  final AddedToCart addedToCart;

  final int presenterId;

  AddToCartPopUp(this.contextA, this.addedToCart, this.presenterId);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return BlocListener<CartBloc, CartStates>(
      listener: (context, state) {
        if (state is LoadCartSuccess) {
          BlocProvider.of<LoadingBloc>(context)..add(StopLoading());
        }
      },
      child: BlocBuilder<LiveStreamCheckoutBloc, LiveStreamStates>(
          builder: (context, state) {
        if (state is ShowProductSuccess)
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: state.product.thumbnail,
                        width: 100,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              state.product.brand != null
                                  ? Text(
                                      state.product.brand,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Container(),
                              Text(
                                appLanguage.appLocal == Locale('en')
                                    ? state.product.nameEn
                                    : state.product.nameAr,
                                softWrap: true,
                                style: TextStyle(fontSize: 16),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '${AppLocalizations.of(context).translate('aed')} ${state.product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      print("TAPPED");

                                      if (state.product.quantity == 1) {
                                        ///delete the item
                                        ///or don do anything
                                      } else {
                                        if (state.product.quantity == null) {
                                          state.product.quantity = 1;
                                        } else
                                          state.product.quantity =
                                              state.product.quantity - 1;
                                        BlocProvider.of<CartBloc>(contextA)
                                          ..add(EditCartItem(
                                              isLoggedIn:
                                                  !(BlocProvider.of<LoginBloc>(
                                                          context)
                                                      .state is GuestUser),
                                              editType: "QUANTITY EDIT",
                                              cartItem: state.product));
                                        BlocProvider.of<LiveStreamCheckoutBloc>(
                                            contextA)
                                          ..add(ShowProduct(state.product));
                                      }
                                    },
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: Text(
                                      state.product.quantity == null
                                          ? "1"
                                          : state.product.quantity.toString(),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print("TAPPED");

                                      if (state.product.quantity == null) {
                                        state.product.quantity = 2;
                                      } else
                                        state.product.quantity =
                                            state.product.quantity + 1;

                                      BlocProvider.of<CartBloc>(contextA)
                                        ..add(EditCartItem(
                                            isLoggedIn:
                                                !(BlocProvider.of<LoginBloc>(
                                                        context)
                                                    .state is GuestUser),
                                            editType: "QUANTITY EDIT",
                                            cartItem: state.product));

                                      BlocProvider.of<LiveStreamCheckoutBloc>(
                                          contextA)
                                        ..add(ShowProduct(state.product));
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: BlocBuilder<LoadingBloc, LoadingStates>(
                          builder: (context, loadingState) {
                        if (loadingState is NotLoading) {
                          return RaisedButton(
                            onPressed: () {
                              state.product.quantity = 1;
                              BlocProvider.of<LoadingBloc>(context)
                                ..add(StartLoading());

                              new RealTimeController().emitAddToCartFromLive(
                                  state.product.id, presenterId);
                              BlocProvider.of<CartBloc>(context).add(
                                  AddCartItem(
                                      isLoggedIn:
                                          !(BlocProvider.of<LoginBloc>(context)
                                              .state is GuestUser),
                                      cartItem: state.product, ));
                            },
                            child: Text("ADD TO CART"),
                          );
                        } else
                          return RaisedButton(
                            onPressed: () {},
                            child: Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                      }))
                ]),
          );
        else
          return Container();
      }),
    );
  }
}
