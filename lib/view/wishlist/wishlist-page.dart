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
import 'package:tienda/view/widgets/loading-widget.dart';
import 'package:tienda/model/wishlist.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../localization.dart';

class WishListPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<WishListPage> {
//  final WishListBloc _wishListBloc = new WishListBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ConnectivityBloc().connectivityStream.listen((value) {
      if (value == ConnectivityResult.none) {
        BlocProvider.of<WishListBloc>(context)..add(OfflineLoadWishList());
      } else {
        BlocProvider.of<WishListBloc>(context)..add(LoadWishListProducts());
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
        ),
        body: BlocBuilder<WishListBloc, WishListStates>(
            builder: (context, state) {
          if (state is LoadWishListSuccess) {
            return buildWishList(state.wishList, context, appLanguage);
          }
          if (state is DeleteWishListItemSuccess) {
            return buildWishList(state.wishList, context, appLanguage);
          }
          if (state is EmptyWishList)
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Center(
                child: Text("WishList is empty"),
              ),
            );
          else {
            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: spinKit),
            );
          }
        }));
  }

  buildWishList(WishList wishList, context, AppLanguage appLanguage) {
    return Container(
      color: Colors.white,
      child: ListView(
        physics: ScrollPhysics(),
        padding: EdgeInsets.only(bottom: 50),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(AppLocalizations.of(context).translate('wishlist'),
                style: Theme.of(context).textTheme.headline2),
          ),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 50),
            shrinkWrap: true,
            itemCount: wishList.wishListItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (MediaQuery.of(context).size.width / 2) /
                    (appLanguage.appLocal == Locale("en") ? 280 : 300),
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200], width: 1)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: wishList
                                  .wishListItems[index].product.thumbnail,
                              width: MediaQuery.of(context).size.width / 2,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 10,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.clear,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      color: Colors.white,
                                      onPressed: () {
                                        BlocProvider.of<WishListBloc>(context)
                                            .add(DeleteWishListItem(
                                                wishList: wishList,
                                                wishListItem: wishList
                                                    .wishListItems[index]));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            appLanguage.appLocal == Locale('en')
                                ? wishList.wishListItems[index].product.nameEn
                                : wishList.wishListItems[index].product.nameAr,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "${AppLocalizations.of(context).translate('aed')} ${wishList.wishListItems[index].product.price}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 20,
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)
                                  .translate("add-to-cart"),
                              style: TextStyle(color: Colors.pink),
                            )),
                            onPressed: () {
                              print("PRODUCT CLICKED");
                              wishList.wishListItems[index].product.quantity =
                                  1;
                              BlocProvider.of<CartBloc>(context).add(
                                  AddCartItem(
                                      isFromLiveStream: false,
                                      cartItem: wishList
                                          .wishListItems[index].product));

                              ///Moved to cart and delete from wish list
                              BlocProvider.of<WishListBloc>(context).add(
                                  DeleteWishListItem(
                                      wishList: wishList,
                                      wishListItem:
                                          wishList.wishListItems[index]));
                            },
                          ),
                        )
                      ],
                    )),
              );
            },
          ),
        ],
      ),
    );
  }
}
