import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/view/cart/cart-page.dart';
import 'package:tienda/view/live-stream/add-to-cart-popup.dart';
import 'package:tienda/view/live-stream/cart-checkout-pop-up.dart';
import 'package:tienda/view/wishlist/wishlist-page.dart';
import 'package:video_player/video_player.dart';

class VideoStreamFullScreenView extends StatefulWidget {
  @override
  _VideoStreamFullScreenViewState createState() =>
      _VideoStreamFullScreenViewState();
}

class _VideoStreamFullScreenViewState extends State<VideoStreamFullScreenView> {
  PanelController panelController = new PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.1),
        ),
        title: Text("Influencer name"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('LIVE'),
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8.0, bottom: 16.0),
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
                    ),
                    Text('3000'),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishListPage()),
              );
            },
            icon: Icon(
              Icons.bookmark,
              size: 20,
            ),
          ),
          IconButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
              icon:
                  BlocBuilder<CartBloc, CartStates>(builder: (context, state) {
                if (state is AddToCartSuccess) {
                  return Badge(
                    badgeContent: Text(
                      state.addedCart.cartItems.length.toString(),
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    child: Icon(
                      Icons.shopping_basket,
                      size: 20,
                    ),
                  );
                } else if (state is LoadCartSuccess) {
                  return Badge(
                    badgeContent: Text(
                      state.cart.cartItems.length.toString(),
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    child: Icon(
                      Icons.shopping_basket,
                      size: 20,
                    ),
                  );
                } else
                  return Icon(
                    Icons.shopping_basket,
                    size: 20,
                  );
              }))
        ],
      ),
      body: Stack(
        children: <Widget>[
          /*Container(
            child: Chewie(
              controller: ChewieController(
                videoPlayerController: VideoPlayerController.network(
                    'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4'),
                autoPlay: true,
                looping: true,
                autoInitialize: true,
                aspectRatio: 16 / 9,
                showControls: false,
                allowFullScreen: true,
              ),
            ),
          ),*/
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/icons/sample.jpg',
              fit: BoxFit.fitHeight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: MediaQuery.of(context).size.width / 4,
                child: ListView.builder(
                    itemCount: 3,
                    padding: EdgeInsets.all(0),
                    itemBuilder: (BuildContext context, int index) =>
                        GestureDetector(
                          onTap: () {
                            panelController.open();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                height: 90,
                                width: 30,
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ),
                          ),
                        )),
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
                            hintText: 'Say Something'),
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
              maxHeight: 300,
              backdropTapClosesPanel: true,
              defaultPanelState: PanelState.CLOSED,
              minHeight: 0,
              controller: panelController,
              panel: AddToCartPopUp()),
          SlidingUpPanel(
              maxHeight: 300,
              backdropTapClosesPanel: true,
              defaultPanelState: PanelState.OPEN,
              minHeight: 300,
              controller: panelController,
              panel: CartCheckOutPopUp()),
        ],
      ),
    );
  }
}
