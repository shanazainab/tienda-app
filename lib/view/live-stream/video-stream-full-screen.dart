import 'dart:async';
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart' as VLC;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/live-stream-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/live-stream-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/live-stream/add-to-cart-popup.dart';
import 'package:tienda/view/live-stream/cart-checkout-pop-up.dart';
import 'package:tienda/view/live-stream/live-comment-box.dart';
import 'package:tienda/view/live-stream/video-playout.dart';
import 'package:tienda/view/wishlist/wishlist-page.dart';

class VideoStreamFullScreenView extends StatefulWidget {
  @override
  _VideoStreamFullScreenViewState createState() =>
      _VideoStreamFullScreenViewState();
}

class _VideoStreamFullScreenViewState extends State<VideoStreamFullScreenView> {
  PanelController addToCartPanelController = new PanelController();
  PanelController checkoutPanelController = new PanelController();
  VLC.VlcPlayerController _videoViewController2;

  final productsVisibility = BehaviorSubject<bool>();

  final backButtonVisibility = BehaviorSubject<bool>();
  VLC.VlcPlayerController _videoViewController;

  FocusNode textFocusNode = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _videoViewController = new VLC.VlcPlayerController(onInit: () {
      _videoViewController.play();
    });
    _videoViewController.addListener(() {
      setState(() {});
    });
    productsVisibility.add(true);
    backButtonVisibility.add(false);
    textFocusNode.addListener(() {
      if (textFocusNode.hasFocus)
        productsVisibility.add(false);
      else
        productsVisibility.add(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: StreamBuilder<bool>(
            stream: backButtonVisibility,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data != null && snapshot.data) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.1),
                  ),
                );
              } else
                return IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios),
                );
            }),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  AppLocalizations.of(context).translate("live").toUpperCase(),
                  style: TextStyle(fontSize: 12),
                ),
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 16.0, bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.remove_red_eye,
                      color: Colors.white,
                      size: 16,
                    ),
                    Text(
                      '3000',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            constraints: BoxConstraints.tight(Size.square(40)),
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishListPage()),
              );
            },
            icon: Icon(
              FontAwesomeIcons.heart,
              size: 20,
              color: Colors.black,
            ),
          ),
          IconButton(
              constraints: BoxConstraints.tight(Size.square(30)),
              padding: EdgeInsets.all(0),
              onPressed: () {
                if (addToCartPanelController.isPanelOpen)
                  addToCartPanelController.close();
                checkoutPanelController.open();
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
                      size: 20,
                      color: Colors.black,
                    ),
                  );
                } else if (state is LoadCartSuccess) {
                  return Badge(
                    badgeContent: Text(
                      state.cart.products.length.toString(),
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    child: Icon(
                      Icons.shopping_basket,
                      size: 20,
                      color: Colors.black,
                    ),
                  );
                } else
                  return Icon(
                    Icons.shopping_basket,
                    size: 20,
                    color: Colors.black,
                  );
              })),
          SizedBox(
            width: 8,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: GestureDetector(onPanStart: (panStartDetails) {
              FocusManager.instance.primaryFocus.unfocus();
              backButtonVisibility.add(!backButtonVisibility.value);
            }, child: BlocBuilder<LiveStreamBloc, LiveStreamStates>(
                builder: (context, state) {
              if (state is JoinLiveSuccess) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: new VLC.VlcPlayer(
                    aspectRatio: MediaQuery.of(context).size.width /
                        MediaQuery.of(context).size.height,
                    url: state.liveResponse.url,
                    controller: _videoViewController,
                    // Play with vlc options
                    options: [
                      '--quiet',
                      '--no-drop-late-frames',
                      '--no-skip-frames',
                      '--rtsp-tcp'
                    ],
                    hwAcc: VLC.HwAcc.DISABLED,
                    // or {HwAcc.AUTO, HwAcc.DECODING, HwAcc.FULL}
                    placeholder: Container(
                      height: 250.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[CircularProgressIndicator()],
                      ),
                    ),
                  ),
                );
              } else
                return Container();
            })),
          ),
          BlocBuilder<LiveStreamBloc, LiveStreamStates>(
              builder: (context, state) {
            if (state is JoinLiveSuccess) {
              return StreamBuilder<bool>(
                  stream: productsVisibility,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.data != null && snapshot.data)
                      return Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: ListView.builder(
                                itemCount: state.liveResponse.products.length,
                                padding: EdgeInsets.all(0),
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    GestureDetector(
                                      onTap: () {
                                        if (checkoutPanelController.isPanelOpen)
                                          checkoutPanelController.close();
                                        addToCartPanelController.open();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Container(
                                            height: 90,
                                            width: 30,
                                           child: CachedNetworkImage(
                                             imageUrl:
                                             state.liveResponse.products[index].thumbnail,
                                             width: MediaQuery.of(context).size.width / 2,
                                             height: 220,
                                             fit: BoxFit.cover,
                                             placeholder: (context, url) => Container(
                                               height: 220,
                                               color: Color(0xfff2f2e4),
                                             ),
                                             errorWidget: (context, url, error) => Container(
                                               height: 220,
                                               color: Color(0xfff2f2e4),
                                             ),
                                           ),
                                          ),
                                        ),
                                      ),
                                    )),
                          ),
                        ),
                      );
                    else
                      return Container();
                  });
            } else
              return Container();
          }),
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width / 4 + 100,
                child: LiveCommentBox(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FaIcon(
                        FontAwesomeIcons.heart,
                        color: Colors.red,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: textFocusNode,
                        decoration: InputDecoration(
                            filled: true,
                            contentPadding: EdgeInsets.only(
                                left: 16, top: 0, bottom: 0, right: 0),
                            fillColor: Colors.black.withOpacity(0.1),
                            focusColor: Colors.black.withOpacity(0.1),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                                borderSide: BorderSide(
                                    color: Colors.black.withOpacity(0.1))),
                            border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                                borderSide: BorderSide(
                                    color: Colors.black.withOpacity(0.1))),
                            hintText: AppLocalizations.of(context)
                                .translate("type-your-comment")),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FaIcon(FontAwesomeIcons.paperPlane,
                          color: Colors.black.withOpacity(0.1)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SlidingUpPanel(
              maxHeight: 320,
              backdropTapClosesPanel: true,
              defaultPanelState: PanelState.CLOSED,
              minHeight: 0,
              controller: addToCartPanelController,
              panel: AddToCartPopUp()),
          SlidingUpPanel(
              maxHeight: 320,
              backdropTapClosesPanel: true,
              defaultPanelState: PanelState.CLOSED,
              minHeight: 0,
              controller: checkoutPanelController,
              panel: CartCheckOutPopUp()),
        ],
      ),
    );
  }
}
