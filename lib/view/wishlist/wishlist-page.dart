import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/connectivity-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/states/wishlist-states.dart';

import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/model/wishlist.dart';

import '../../localization.dart';

class WishListPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<WishListPage> {
  final WishListBloc _wishListBloc = new WishListBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ConnectivityBloc().connectivityStream.listen((value) {
      if (value == ConnectivityResult.none) {
        _wishListBloc..add(OfflineLoadWishList());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          title: Text(
            AppLocalizations.of(context).translate('wishlist'),
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: BlocBuilder<WishListBloc, WishListStates>(
            bloc: _wishListBloc..add(LoadWishListProducts()),
            builder: (context, state) {
              if (state is LoadWishListSuccess) {
                return buildWishList(state.wishList, context, appLanguage);
              } else if (state is DeleteWishListItemSuccess) {
                return buildWishList(state.wishList, context, appLanguage);
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                );
              }
            }));
  }

  buildWishList(WishList wishList, context, AppLanguage appLanguage) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: wishList.wishListItems.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.2),
          crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return new Card(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: wishList.wishListItems[index].product.thumbnail,
                  width: MediaQuery.of(context).size.width / 2,
                  height: 180,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Container(
                    color: Color(0xfff2f2e4),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<WishListBloc>(context).add(
                            DeleteWishListItem(
                                wishList: wishList,
                                wishListItem: wishList.wishListItems[index]));
                      },
                      icon: Icon(
                        Icons.clear,
                        size: 18,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Text(
              appLanguage.appLocal == Locale('en')
                  ? wishList.wishListItems[index].product.nameEn
                  : wishList.wishListItems[index].product.nameAr,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            Text("${AppLocalizations.of(context).translate('aed')} ${wishList.wishListItems[index].product.price}"),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 20,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                child: Center(
                    child: Text(
                  AppLocalizations.of(context).translate("add-to-cart"),
                  style: TextStyle(color: Colors.pink),
                )),
                onPressed: () {
                  print("PRODUCT CLICKED");
                  wishList.wishListItems[index].product.quantity = 1;
                  BlocProvider.of<CartBloc>(context).add(AddCartItem(
                      cartItem: wishList.wishListItems[index].product));

                  ///Moved to cart and delete from wish list
                  BlocProvider.of<WishListBloc>(context).add(DeleteWishListItem(
                      wishList: wishList,
                      wishListItem: wishList.wishListItems[index]));
                },
              ),
            )
          ],
        ));
      },
    );
  }
}
