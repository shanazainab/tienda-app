import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/states/wishlist-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/login/login-main-page.dart';
import 'package:tienda/view/wishlist/wishlist-page.dart';

class WishListMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<WishListBloc, WishListStates>(
        listener: (context, state) {
          if (state is AuthorizationFailed) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginMainPage()),
            );
          }
        },
        child: DefaultTabController(
            length: 3,
            child: new Scaffold(
                appBar: AppBar(
                  brightness: Brightness.light,
                  title:
                      Text(AppLocalizations.of(context).translate("wishlist")),
                  centerTitle: true,
                  bottom: TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.blue,
                      labelColor: Colors.grey,
                      unselectedLabelColor: Colors.grey,
                      unselectedLabelStyle: TextStyle(color: Colors.grey),
                      tabs: [
                        Tab(
                          text: AppLocalizations.of(context).translate("all"),
                        ),
                        Tab(
                          text: AppLocalizations.of(context)
                              .translate("on-discount"),
                        ),
                        Tab(
                          text:
                              AppLocalizations.of(context).translate("popular"),
                        ),
                      ]),
                ),
                body: BlocBuilder<WishListBloc, WishListStates>(
                    bloc: BlocProvider.of<WishListBloc>(context)
                      ..add(LoadWishListProducts()),
                    builder: (context, state) {
                      if (state is LoadWishListSuccess) {
                        if (state.wishList == null) {
                          return Container(
                            child:
                                Center(child: Text("No products in WishList")),
                          );
                        }
                        return TabBarView(children: [
                          WishListPage(state.wishList, context),
                          WishListPage(state.wishList, context),
                          WishListPage(state.wishList, context),

                        ]);
                      } else if (state is DeleteWishListItemSuccess) {
                        return TabBarView(children: [
                          WishListPage(state.wishList, context),
                          WishListPage(state.wishList, context),
                          WishListPage(state.wishList, context),

                        ]);
                      } else {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        );
                      }
                    }))));
  }
}
