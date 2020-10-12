import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tienda/bloc/bottom-nav-bar-bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/events/bottom-nav-bar-events.dart';
import 'package:tienda/bloc/events/presenter-message-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/startup-bloc.dart';
import 'package:tienda/bloc/states/bottom-nav-bar-states.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/presenter-message-states.dart';
import 'package:tienda/bloc/states/startup-states.dart';
import 'package:tienda/bloc/unreadmessage-bloc.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/video-overlays/overlay_handler.dart';
import 'package:tienda/view/home/home-screen.dart';

class BottomNavFloatingBar extends StatefulWidget {
  @override
  _BottomNavFloatingBarState createState() => _BottomNavFloatingBarState();
}

class _BottomNavFloatingBarState extends State<BottomNavFloatingBar> {
  RealTimeController realTimeController = new RealTimeController();
  int previousIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<BottomNavBarBloc, BottomNavBarStates>(
      listener: (context, state) {
        if (state is ChangeBottomNavBarIndexSuccess) {
          if (state.index != previousIndex) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
          if (Provider.of<OverlayHandlerProvider>(context, listen: false)
                      .overlayEntry !=
                  null &&
              !Provider.of<OverlayHandlerProvider>(context, listen: false)
                  .inPipMode) {
            Provider.of<OverlayHandlerProvider>(context, listen: false)
                .enablePip(3 / 2);
          }

          previousIndex = state.index;

          pageController.jumpToPage(state.index);
        }
      },
      child: Consumer<OverlayHandlerProvider>(
          builder: (context, overlayProvider, _) {
        if (!overlayProvider.inFullScreenMode)

          return BlocBuilder<StartupBloc, StartupStates>(
              builder: (context, state) {
                if(state is PreferenceFlowFetchComplete && state.route == '/homePage')
                  return Container(
                    height: 58,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            child: Container(
                                height: 46,
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

                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0x28606170),
                                        offset: Offset(0, 8),
                                        blurRadius: 16,
                                        spreadRadius: 0),
                                    BoxShadow(
                                        color: Color(0x0a28293d),
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                        spreadRadius: 0)
                                  ],
                                ),
                                child:
                                BlocBuilder<BottomNavBarBloc, BottomNavBarStates>(
                                    builder: (context, state) {
                                      if (state is ChangeBottomNavBarIndexSuccess)
                                        return BottomNavigationBar(
                                          onTap: (index) {
                                            BlocProvider.of<BottomNavBarBloc>(context)
                                                .add(ChangeBottomNavBarIndex(index));
                                          },
                                          type: BottomNavigationBarType.fixed,
                                          currentIndex: state.index,
                                          elevation: 16,
                                          selectedLabelStyle:
                                          TextStyle(fontSize: 11, color: Colors.black),
                                          unselectedFontSize: 0,
                                          selectedItemColor: Color(0xFFff2e63),
                                          selectedFontSize: 8,
                                          unselectedLabelStyle: TextStyle(fontSize: 11),
                                          unselectedItemColor: Colors.black,
                                          iconSize: 20,
                                          items: [
                                            BottomNavigationBarItem(
                                                icon: SvgPicture.asset(
                                                  "assets/svg/home.svg",
                                                  color: state.index == 0
                                                      ? Color(0xFFff2e63)
                                                      : Colors.black,
                                                ),
                                                label: 'Home'),
                                            BottomNavigationBarItem(
                                                icon: Padding(
                                                  padding: const EdgeInsets.all(0.0),
                                                  child: SvgPicture.string(
                                                    state.index != 1
                                                        ? '''<svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M1.55401 12.132C1.25732 11.9225 1.27582 11.4766 1.58884 11.2925L8.74649 7.08212C8.90296 6.99008 9.09704 6.99008 9.25351 7.08212L16.4112 11.2925C16.7242 11.4766 16.7427 11.9225 16.446 12.132L9.28834 17.1844C9.11548 17.3064 8.88452 17.3064 8.71166 17.1844L1.55401 12.132Z" fill="white" stroke="black"/>
                                <path d="M1.55401 8.95556C1.25732 8.74613 1.27582 8.30024 1.58884 8.11611L8.74649 3.90573C8.90296 3.81368 9.09704 3.81368 9.25351 3.90573L16.4112 8.11611C16.7242 8.30024 16.7427 8.74613 16.446 8.95556L9.28834 14.008C9.11548 14.13 8.88452 14.13 8.71166 14.008L1.55401 8.95556Z" fill="white" stroke="black"/>
                                <path d="M1.55401 5.77905C1.25732 5.56962 1.27582 5.12373 1.58884 4.9396L8.74649 0.729214C8.90296 0.63717 9.09704 0.63717 9.25351 0.729214L16.4112 4.93959C16.7242 5.12373 16.7427 5.56962 16.446 5.77905L9.28834 10.8315C9.11548 10.9535 8.88452 10.9535 8.71166 10.8315L1.55401 5.77905Z" fill="white" stroke="black"/>
                                </svg>'''
                                                        : '''<svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M1.55401 12.132C1.25732 11.9225 1.27582 11.4766 1.58884 11.2925L8.74649 7.08212C8.90296 6.99008 9.09704 6.99008 9.25351 7.08212L16.4112 11.2925C16.7242 11.4766 16.7427 11.9225 16.446 12.132L9.28834 17.1844C9.11548 17.3064 8.88452 17.3064 8.71166 17.1844L1.55401 12.132Z" fill="white" stroke="#ff2e63"/>
                                <path d="M1.55401 8.95556C1.25732 8.74613 1.27582 8.30024 1.58884 8.11611L8.74649 3.90573C8.90296 3.81368 9.09704 3.81368 9.25351 3.90573L16.4112 8.11611C16.7242 8.30024 16.7427 8.74613 16.446 8.95556L9.28834 14.008C9.11548 14.13 8.88452 14.13 8.71166 14.008L1.55401 8.95556Z" fill="white" stroke="#ff2e63"/>
                                <path d="M1.55401 5.77905C1.25732 5.56962 1.27582 5.12373 1.58884 4.9396L8.74649 0.729214C8.90296 0.63717 9.09704 0.63717 9.25351 0.729214L16.4112 4.93959C16.7242 5.12373 16.7427 5.56962 16.446 5.77905L9.28834 10.8315C9.11548 10.9535 8.88452 10.9535 8.71166 10.8315L1.55401 5.77905Z" fill="white" stroke="#ff2e63"/>
                                </svg>''',
                                                  ),
                                                ),
                                                label: 'Categories'),
                                            BottomNavigationBarItem(
                                                icon: Container(
                                                  height: 0,
                                                ),
                                                label: ''),
                                            BottomNavigationBarItem(
                                                icon: Container(
                                                  height: 21,
                                                  child: Stack(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.center,
                                                        child: SvgPicture.asset(
                                                          "assets/svg/cart.svg",
                                                          color: state.index == 3
                                                              ? Color(0xFFff2e63)
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                      BlocBuilder<CartBloc, CartStates>(
                                                          builder: (context, state) {
                                                            if (state is AddToCartSuccess) {
                                                              return Padding(
                                                                padding: const EdgeInsets.only(
                                                                    left: 4.0, top: 0),
                                                                child: Align(
                                                                  alignment:
                                                                  Alignment.topCenter,
                                                                  child: Text(
                                                                    state.addedCart.products
                                                                        .length
                                                                        .toString(),
                                                                    style:
                                                                    TextStyle(fontSize: 12),
                                                                  ),
                                                                ),
                                                              );
                                                            } else if (state
                                                            is LoadCartSuccess) {
                                                              if (state.cart != null)
                                                                return Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(
                                                                      left: 4.0, top: 0),
                                                                  child: Align(
                                                                    alignment:
                                                                    Alignment.topCenter,
                                                                    child: Text(
                                                                      state.cart.products.length
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize: 10),
                                                                    ),
                                                                  ),
                                                                );
                                                              else {
                                                                return Padding(
                                                                    padding:
                                                                    const EdgeInsets.only(
                                                                        left: 4.0, top: 0),
                                                                    child: Align(
                                                                      alignment:
                                                                      Alignment.topCenter,
                                                                      child: Text(
                                                                        "0",
                                                                        style: TextStyle(
                                                                            fontSize: 12),
                                                                      ),
                                                                    ));
                                                              }
                                                            } else
                                                              return Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(
                                                                      left: 4.0, top: 0),
                                                                  child: Align(
                                                                    alignment:
                                                                    Alignment.topCenter,
                                                                    child: Text(
                                                                      "0",
                                                                      style: TextStyle(
                                                                          fontSize: 12),
                                                                    ),
                                                                  ));
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                                label: 'Cart'),
                                            BottomNavigationBarItem(
                                                icon: BlocBuilder<LoginBloc, LoginStates>(
                                                    builder: (context, state) {
                                                      if (state is LoggedInUser)
                                                        return BlocBuilder<CustomerProfileBloc,
                                                            CustomerProfileStates>(
                                                            builder: (context, state) {
                                                              if (state
                                                              is LoadCustomerProfileSuccess)
                                                                return BlocBuilder<
                                                                    UnreadMessageHydratedBloc,
                                                                    PresenterMessageStates>(
                                                                    builder:
                                                                        (context, messageState) {
                                                                      if (messageState
                                                                      is MessageReceivedSuccess) {
                                                                        int count = 0;

                                                                        for (final messageItem
                                                                        in messageState
                                                                            .unReadMessages) {
                                                                          count = count +
                                                                              messageItem
                                                                                  .messages.length;
                                                                        }

                                                                        return Badge(
                                                                          badgeContent: Text(
                                                                            count.toString(),
                                                                            style: TextStyle(
                                                                                fontSize: 9,
                                                                                color: Colors.white),
                                                                          ),
                                                                          showBadge:
                                                                          count == 0 ? false : true,
                                                                          child: CircleAvatar(
                                                                              radius: 10.5,
                                                                              backgroundColor:
                                                                              Color(0xfff2f2e4),
                                                                              backgroundImage:
                                                                              CachedNetworkImageProvider(
                                                                                  "${GlobalConfiguration().getString("imageURL")}/${state.customerDetails.profilePicture}")),
                                                                        );
                                                                      } else {
                                                                        return CircleAvatar(
                                                                            radius: 10.5,
                                                                            backgroundColor:
                                                                            Color(0xfff2f2e4),
                                                                            backgroundImage:
                                                                            CachedNetworkImageProvider(
                                                                                "${GlobalConfiguration().getString("imageURL")}/${state.customerDetails.profilePicture}"));
                                                                      }
                                                                    });

                                                              if (state is NoCustomerData)
                                                                return CircleAvatar(
                                                                    radius: 10.5,
                                                                    backgroundColor:
                                                                    Color(0xfff2f2e4),
                                                                    backgroundImage: AssetImage(
                                                                        "assets/images/profile-placeholder.png"));
                                                              if (state
                                                              is OfflineLoadCustomerDataSuccess)
                                                                return CircleAvatar(
                                                                    radius: 10.5,
                                                                    backgroundColor:
                                                                    Color(0xfff2f2e4),
                                                                    backgroundImage:
                                                                    CachedNetworkImageProvider(
                                                                        "${GlobalConfiguration().getString("imageURL")}/${state.customerDetails.profilePicture}"));
                                                              else
                                                                return CircleAvatar(
                                                                    radius: 10.5,
                                                                    backgroundColor:
                                                                    Color(0xfff2f2e4),
                                                                    backgroundImage: AssetImage(
                                                                        "assets/images/profile-placeholder.png"));
                                                            });
                                                      else
                                                        return CircleAvatar(
                                                            radius: 10.5,
                                                            backgroundColor: Color(0xfff2f2e4),
                                                            backgroundImage: AssetImage(
                                                                "assets/images/profile-placeholder.png"));
                                                    }),
                                                label: 'Account')
                                          ],
                                        );
                                      else
                                        return Container();
                                    })),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xfff0752d),
                                  Color(0xffee456f),
                                  Color(0xff893ccc)
                                ],
                                stops: [0, 0.4791666567325592, 1],
                                begin: Alignment(-1.00, 0.00),
                                end: Alignment(1.00, -0.00),
                                // angle: 0,
                                // scale: undefined,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: FloatingActionButton(
                                onPressed: () {
                                  BlocProvider.of<BottomNavBarBloc>(context)
                                      .add(ChangeBottomNavBarIndex(2));

                                  pageController.jumpToPage(2);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: SvgPicture.asset(
                                    "assets/svg/shop-live.svg",
                                    height: 22,
                                  ),
                                ),
                                elevation: 2.0,
                                backgroundColor: Color(0xFFff2e63),

                                ///#ff2e63
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(
                                width: 35,
                                height: 13,
                                alignment: Alignment.center,
                                child: Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xfff0752d),
                                        Color(0xffee456f),
                                        Color(0xff893ccc)
                                      ],
                                      stops: [0, 0.4791666567325592, 1],
                                      begin: Alignment(-1.00, 0.00),
                                      end: Alignment(1.00, -0.00),
                                      // angle: 0,
                                      // scale: undefined,
                                    ))),
                          ),
                        )
                      ],
                    ),
                  );
                else
                  return Container();
              }
          );


        else
          return Container();
      }),
    );
  }
}
