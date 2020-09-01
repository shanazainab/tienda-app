import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/live-stream-checkout-bloc.dart';
import 'package:tienda/bloc/states/live-stream-states.dart';
import 'package:tienda/localization.dart';
import 'package:transparent_image/transparent_image.dart';

typedef AddedToCart = Function(bool value);

class AddToCartPopUp extends StatelessWidget {
  final BuildContext contextA;

  final AddedToCart addedToCart;

  AddToCartPopUp(this.contextA,this.addedToCart);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return BlocBuilder<LiveStreamCheckoutBloc, LiveStreamStates>(
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
                    FadeInImage.memoryNetwork(
                      image: state.product.thumbnail,
                      width: 100,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: kTransparentImage,

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
                                    fontWeight: FontWeight.bold, fontSize: 16),
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
                                            //  cart: state.cart,
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
                                          //    cart: state.cart,
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
                  child: RaisedButton(
                    onPressed: () {
                      BlocProvider.of<CartBloc>(context)
                          .add(AddCartItem(cartItem: state.product));
                      addedToCart(true);
                    },
                    child: Text("ADD TO CART"),
                  ),
                )
              ]),
        );
      else
        return Container();
    });
  }
}
