import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/live-events.dart';
import 'package:tienda/bloc/events/preference-events.dart';
import 'package:tienda/bloc/live-contents-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/preference-bloc.dart';
import 'package:tienda/bloc/search/search-bloc.dart';
import 'package:tienda/bloc/search/search-events.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/view/cart/page/cart-page.dart';
import 'package:tienda/view/login/login-main-page.dart';
import 'package:tienda/view/search/page/search-page.dart';
import 'package:tienda/view/wishlist/wishlist-page.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showCart;
  final bool showWishList;
  final bool showLogo;
  final bool showSearch;
  final bool showNotification;
  final Widget bottom;

  final bool extend;

  CustomAppBar(
      {this.title,
      this.extend,
      this.showCart,
      this.showNotification,
      this.showWishList,
      this.showLogo,
      this.showSearch,
      this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor:
          extend != null && extend ? Colors.transparent : Colors.white,
      elevation: 0,
      title: showLogo
          ? SvgPicture.asset("assets/svg/tienda.svg", height: 24, width: 84)
          : Text(title),
      centerTitle: false,
      automaticallyImplyLeading: showLogo ? false : true,
      bottom: bottom != null ? bottom : null,
      actions: <Widget>[
        if (showSearch)
          IconButton(
            constraints: BoxConstraints.tight(Size.square(40)),
            padding: EdgeInsets.all(0),
            visualDensity: VisualDensity.compact,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider<PreferenceBloc>(
                              create: (BuildContext context) => PreferenceBloc()
                                ..add(FetchPreferredCategoryList()),
                            ),
                            BlocProvider<SearchBloc>(
                              create: (BuildContext context) =>
                                  SearchBloc()..add(LoadSearchHistory()),
                            ),
                            BlocProvider<LiveContentsBloc>(
                              create: (BuildContext context) =>
                                  LiveContentsBloc()..add(LoadCurrentLiveVideoList()),
                            ),
                          ],
                          child: SearchPage(),
                        )),
              );
            },
            icon: SvgPicture.asset(
              "assets/svg/search.svg",
            ),
          ),
        SizedBox(
          width: 8,
        ),
//        if (showNotification != null && showNotification)
//          IconButton(
//            constraints: BoxConstraints.tight(Size.square(40)),
//            padding: EdgeInsets.all(0),
//            visualDensity: VisualDensity.compact,
//            onPressed: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => NotificationScreen()),
//              );
//            },
//            icon: Icon(
//              Icons.notifications_none,
//            ),
//          ),
        if (showWishList)
          IconButton(
            visualDensity: VisualDensity.compact,
            constraints: BoxConstraints.tight(Size.square(40)),
            padding: EdgeInsets.all(0),
            onPressed: () {
              BlocProvider.of<LoginBloc>(context).state is GuestUser
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginMainPage()),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WishListPage()),
                    );
            },
            icon: Icon(
              FontAwesomeIcons.heart,
              size: 20,
            ),
          ),
        if (showCart)
          IconButton(
              visualDensity: VisualDensity.compact,
              constraints: BoxConstraints.tight(Size.square(50)),
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return CartPage();
                  }),
                );
              },
              icon:
                  BlocBuilder<CartBloc, CartStates>(builder: (context, state) {
                if (state is AddToCartSuccess) {
                  return Badge(
                    badgeContent: Text(
                      state.addedCart.products.length.toString(),
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    child: Icon(
                      Icons.shopping_basket,
                    ),
                  );
                } else if (state is LoadCartSuccess) {
                  if (state.cart != null)
                    return Badge(
                      badgeContent: Text(
                        state.cart.products.length.toString(),
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      child: Icon(
                        Icons.shopping_basket,
                      ),
                    );
                  else
                    return Icon(
                      Icons.shopping_basket,
                    );
                } else
                  return Icon(
                    Icons.shopping_basket,
                  );
              })),
        SizedBox(
          width: 8,
        )
      ],
    );
  }
}
