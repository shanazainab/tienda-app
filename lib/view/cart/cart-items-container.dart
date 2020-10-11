import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/loading-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/cart.dart';
import 'package:tienda/model/wishlist.dart';
import 'package:tienda/video-overlays/overlay_service.dart';
import 'package:tienda/view/products/product-review-page.dart';
import 'package:transparent_image/transparent_image.dart';

class CartItemsContainer extends StatelessWidget {
  final Cart cart;

  final RealTimeController realTimeController = new RealTimeController();

  CartItemsContainer(this.cart);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Divider(

        );
      },
      physics: ScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      itemCount: cart.products.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            OverlayService().addVideoTitleOverlay(context,
                ProductReviewPage(cart.products[index].id), false, false);
          },
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child:new Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeInImage.memoryNetwork(
                          image: cart.products[index].thumbnail,
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
                                cart.products[index].brand != null
                                    ? Text(
                                  cart.products[index].brand,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                )
                                    : Container(),
                                Text(
                                  appLanguage.appLocal == Locale('en')
                                      ? cart.products[index].nameEn
                                      : cart.products[index].nameAr,
                                  softWrap: true,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                BlocProvider.of<LoadingBloc>(context)
                                                  ..add(StartLoading());

                                                if (cart.products[index].quantity ==
                                                    1) {
                                                  ///delete the item
                                                  ///or don do anything
                                                } else {
                                                  cart.products[index].quantity =
                                                      cart.products[index].quantity -
                                                          1;
                                                  BlocProvider.of<CartBloc>(context)
                                                    ..add(EditCartItem(
                                                        cart: cart,
                                                        isLoggedIn: !(BlocProvider.of<
                                                            LoginBloc>(context)
                                                            .state is GuestUser),
                                                        editType: "QUANTITY EDIT",
                                                        cartItem:
                                                        cart.products[index]));
                                                }
                                              },
                                              child: Text(
                                                "-",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0, right: 12),
                                              child: Text(
                                                cart.products[index].quantity
                                                    .toString(),
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                BlocProvider.of<LoadingBloc>(context)
                                                  ..add(StartLoading());

                                                cart.products[index].quantity =
                                                    cart.products[index].quantity + 1;

                                                BlocProvider.of<CartBloc>(context)
                                                  ..add(EditCartItem(
                                                      cart: cart,
                                                      isLoggedIn: !(BlocProvider.of<
                                                          LoginBloc>(context)
                                                          .state is GuestUser),
                                                      editType: "QUANTITY EDIT",
                                                      cartItem:
                                                      cart.products[index]));
                                              },
                                              child: Text(
                                                "+",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context).translate('aed')} ${cart.products[index].price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffAF0044)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    StreamBuilder<Map<String, dynamic>>(
                        stream: realTimeController.liveCheckOutStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          var count;

                          print("PRODUCT ID IN :${cart.products[index].id}");
                          if (snapshot.data != null) {
                            for (final productId in snapshot.data.keys.toList()) {
                              print("PRODUCT KEY : $productId");
                              if (productId == cart.products[index].id.toString()) {
                                count = snapshot.data[productId];
                              }
                            }
                            return count == null
                                ? Container()
                                : Align(
                              alignment: Alignment.center,
                              child: Text(
                                "$count added this product to cart",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else
                            return Container();
                        }),

                  ],
                )),

            secondaryActions: <Widget>[
              IconSlideAction(
                caption:  AppLocalizations.of(context)
                    .translate('move-to-wishlist')
                    .toUpperCase(),
                color: Colors.blue,
                icon: Icons.bookmark,
                onTap: (){ BlocProvider.of<LoadingBloc>(context)
                  ..add(StartLoading());

                BlocProvider.of<WishListBloc>(context).add(AddToWishList(
                    wishListItem: new WishListItem(
                      product: cart.products[index],
                    )));

                BlocProvider.of<CartBloc>(context).add(DeleteCartItem(
                    isLoggedIn: !(BlocProvider.of<LoginBloc>(context)
                        .state is GuestUser),
                    cart: cart,
                    cartItem: cart.products[index]));},
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.indigo,
                icon: Icons.delete,
                onTap: () {
                  BlocProvider.of<LoadingBloc>(context)
                    ..add(StartLoading());

                  BlocProvider.of<CartBloc>(context).add(DeleteCartItem(
                      isLoggedIn: !(BlocProvider.of<LoginBloc>(context)
                          .state is GuestUser),
                      cart: cart,
                      cartItem: cart.products[index]));
                },
              ),
            ],
          )





        );
      },
    );
  }
}
