import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/events/presenter-message-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/presenter-message-states.dart';
import 'package:tienda/bloc/unreadmessage-bloc.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/view/home/home-screen.dart';

class BottomNavFloatingBar extends StatefulWidget {
  @override
  _BottomNavFloatingBarState createState() => _BottomNavFloatingBarState();
}

class _BottomNavFloatingBarState extends State<BottomNavFloatingBar> {
  int _currentBarIndex = 0;

  RealTimeController realTimeController = new RealTimeController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    realTimeController.unReadMessage.listen((value) {
      Logger().d("UNREAD LISTNER CALLED");
      if (value != null) {
        BlocProvider.of<UnreadMessageHydratedBloc>(context)
            .add(MessageReceivedEvent(value));
      }
    });
  }

  void _selectedTab(int index) {
    if (index != _currentBarIndex) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }

    setState(() {
      _currentBarIndex = index;
    });

    pageController.jumpToPage(_currentBarIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              child: Container(
                height: 44,
                width: MediaQuery.of(context).size.width - 32,
                decoration: new BoxDecoration(
                  ///border: border-width border-style border-color|initial|inherit;
                  ///border: solid 0.5px rgba(85, 85, 85, 0.2);
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromRGBO(85, 85, 85, 0.2),
                          width: 0.2,
                          style: BorderStyle.solid),
                      right: BorderSide(
                          color: Color.fromRGBO(85, 85, 85, 0.2),
                          width: 0.2,
                          style: BorderStyle.solid),
                      left: BorderSide(
                          color: Color.fromRGBO(85, 85, 85, 0.2),
                          width: 0.2,
                          style: BorderStyle.solid),
                      top: BorderSide(
                          color: Color.fromRGBO(85, 85, 85, 0.2),
                          width: 0.2,
                          style: BorderStyle.solid)),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),

                  // boxShadow: [
                  //   ///box-shadow: 0 8px 16px 0 rgba(96, 97, 112, 0.16), 0 2px 4px 0 rgba(40, 41, 61, 0.04);
                  //   ///box-shadow: none|h-offset v-offset blur spread color |inset|initial|inherit;
                  //
                  //   BoxShadow(
                  //     color: Color.fromRGBO(96, 97, 112, 0.16),
                  //     blurRadius: 0.0, // soften the shadow
                  //     spreadRadius: 0.0, //extend the shadow
                  //     offset: Offset(
                  //       8.0, // Move to right 10  horizontally
                  //       16.0, // Move to bottom 10 Vertically
                  //     ),
                  //   ),
                  //   BoxShadow(
                  //     color: Color.fromRGBO(40, 41, 61, 0.04),
                  //     blurRadius: 0.0, // soften the shadow
                  //     spreadRadius: 0.0, //extend the shadow
                  //     offset: Offset(
                  //       2.0, // Move to right 10  horizontally
                  //       4.0, // Move to bottom 10 Vertically
                  //     ),
                  //   )
                  // ],


                  boxShadow: [BoxShadow(
                      color: Color(0x28606170),
                      offset: Offset(0,8),
                      blurRadius: 16,
                      spreadRadius: 0
                  ),BoxShadow(
                      color: Color(0x0a28293d),
                      offset: Offset(0,2),
                      blurRadius: 4,
                      spreadRadius: 0
                  ) ],



                ),
                child: BottomNavigationBar(
                  onTap: _selectedTab,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _currentBarIndex,
                  elevation: 8,
                  selectedLabelStyle: TextStyle(fontSize: 0),
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  unselectedFontSize: 0,
                  selectedItemColor: Color(0xFFff2e63),
                  unselectedItemColor: Colors.black,
                  iconSize: 20,
                  items: [
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/svg/home.svg",
                          color: _currentBarIndex == 0
                              ? Color(0xFFff2e63)
                              : Colors.black,
                        ),
                        title: Text('Personal')),
                    BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SvgPicture.asset(
                            "assets/svg/category.svg",
                            // color: _currentBarIndex == 1? Color(0xFFff2e63): Colors.black,
                          ),
                        ),
                        title: Text('Personal')),
                    BottomNavigationBarItem(
                        icon: Container(
                          height: 0,
                        ),
                        title: Text('Personal')),
                    BottomNavigationBarItem(
                        icon: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                "assets/svg/cart.svg",
                                color: _currentBarIndex == 3
                                    ? Color(0xFFff2e63)
                                    : Colors.black,
                              ),
                            ),
                            BlocBuilder<CartBloc, CartStates>(
                                builder: (context, state) {
                              if (state is AddToCartSuccess) {
                                return Positioned(
                                    bottom: 12,
                                    left: 34,
                                    child: Text(
                                      state.addedCart.products.length
                                          .toString(),
                                      style: TextStyle(fontSize: 12),
                                    ));
                              } else if (state is LoadCartSuccess) {
                                if (state.cart != null)
                                  return Positioned(
                                      bottom: 12,
                                      left: 34,
                                      child: Text(
                                        state.cart.products.length.toString(),
                                        style: TextStyle(fontSize: 12),
                                      ));
                                else
                                  return Positioned(
                                      bottom: 12,
                                      left: 34,
                                      child: Text(
                                        "0",
                                        style: TextStyle(fontSize: 12),
                                      ));
                              } else
                                return Positioned(
                                    bottom: 12,
                                    left: 34,
                                    child: Text(
                                      "0",
                                      style: TextStyle(fontSize: 12),
                                    ));
                            }),
                          ],
                        ),
                        title: Text('Personal')),
                    BottomNavigationBarItem(
                        icon: BlocBuilder<LoginBloc, LoginStates>(
                            builder: (context, state) {
                          if (state is LoggedInUser)
                            return BlocBuilder<CustomerProfileBloc,
                                    CustomerProfileStates>(
                                builder: (context, state) {
                              if (state is LoadCustomerProfileSuccess)
                                return BlocBuilder<UnreadMessageHydratedBloc,
                                        PresenterMessageStates>(
                                    builder: (context, messageState) {
                                  if (messageState is MessageReceivedSuccess) {
                                    int count = 0;

                                    for (final messageItem
                                        in messageState.unReadMessages) {
                                      count =
                                          count + messageItem.messages.length;
                                    }

                                    return Badge(
                                      badgeContent: Text(
                                        count.toString(),
                                        style: TextStyle(
                                            fontSize: 9, color: Colors.white),
                                      ),
                                      showBadge: count == 0?false:true,

                                      child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Color(0xfff2f2e4),
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  "${GlobalConfiguration().getString("imageURL")}/${state.customerDetails.profilePicture}")),
                                    );
                                  } else {
                                    return Container();
                                  }
                                });

                              if (state is NoCustomerData)
                                return CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Color(0xfff2f2e4),
                                    backgroundImage: AssetImage(
                                        "assets/images/profile-placeholder.png"));
                              if (state is OfflineLoadCustomerDataSuccess)
                                return CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Color(0xfff2f2e4),
                                    backgroundImage: CachedNetworkImageProvider(
                                        "${GlobalConfiguration().getString("imageURL")}/${state.customerDetails.profilePicture}"));
                              else
                                return CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Color(0xfff2f2e4),
                                    backgroundImage: AssetImage(
                                        "assets/images/profile-placeholder.png"));
                            });
                          else
                            return CircleAvatar(
                                radius: 16,
                                backgroundColor: Color(0xfff2f2e4),
                                backgroundImage: AssetImage(
                                    "assets/images/profile-placeholder.png"));
                        }),
                        title: Text('Personal'))
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 44,
              width: 44,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _currentBarIndex = 2;
                  });
                  pageController.jumpToPage(2);
                },

                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: SvgPicture.asset(
                    "assets/svg/Path.svg",
                  ),
                ),
                elevation: 2.0,
                backgroundColor: Color(0xFFff2e63),

                ///#ff2e63
              ),
            ),
          ),
        ],
      ),
    );
  }
}
