import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/live-stream-bloc.dart';
import 'package:tienda/bloc/live-stream-checkout-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/live-stream-states.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/main.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/view/live-stream/add-to-cart-popup.dart';
import 'package:tienda/view/live-stream/cart-checkout-pop-up.dart';
import 'package:tienda/view/live-stream/live-comment-box.dart';
import 'package:tienda/view/live-stream/presenter-profile-card.dart';
import 'package:tienda/view/wishlist/wishlist-page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LiveStreamScreen extends StatefulWidget {
  final Presenter presenter;

  LiveStreamScreen(this.presenter);

  @override
  _LiveStreamScreenState createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  PanelController addToCartPanelController = new PanelController();
  PanelController checkoutPanelController = new PanelController();

  RealTimeController realTimeController = new RealTimeController();

  final productsVisibility = BehaviorSubject<bool>();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  BurstController burstController = new BurstController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    new RealTimeController().emitJoinLive(widget.presenter.id);

    productsVisibility.add(false);

    realTimeController.liveReaction.listen((value) async {
      if (value != null && value) {
        await Future.delayed(const Duration(seconds: 3));
        realTimeController.stopLiveReaction();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        realTimeController.clearLiveChat();
        return Future.value(true);
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colors.transparent.withOpacity(0.1),
            centerTitle: false,
            title: BlocBuilder<LiveStreamBloc, LiveStreamStates>(
                builder: (context, state) {
              if (state is JoinLiveSuccess) {
                return PresenterProfileCard(
                    widget.presenter, state.liveResponse.isFollowed);
              } else
                return Container();
            }),
            actions: <Widget>[
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                backgroundColor: Colors.black54,
                radius: 15,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: BlocBuilder<CartBloc, CartStates>(
                      builder: (context, state) {
                    if (state is AddToCartSuccess) {
                      return Badge(
                        badgeContent: Text(
                          state.addedCart.products.length.toString(),
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                        child: Icon(
                          Icons.shopping_basket,
                          size: 20,
                          color: Colors.white,
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
                          color: Colors.white,
                        ),
                      );
                    } else
                      return Icon(
                        Icons.shopping_basket,
                        size: 20,
                        color: Colors.white,
                      );
                  }),
                  color: Colors.white,
                  onPressed: () {
                    if (addToCartPanelController.isPanelOpen)
                      addToCartPanelController.close();
                    if (checkoutPanelController.isPanelOpen)
                      checkoutPanelController.close();
                    else {
                      checkoutPanelController.open();
                    }
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          body: BlocBuilder<LiveStreamBloc, LiveStreamStates>(
              builder: (context, state) {
            if (state is JoinLiveSuccess) {
              VideoPlayerController _controller =
                  VideoPlayerController.network(state.liveResponse.m3u8URL);
              return Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: GestureDetector(
                        onPanStart: (panStartDetails) {
                          FocusManager.instance.primaryFocus.unfocus();
                        },
                        // https://assets4.lottiefiles.com/packages/lf20_YJZWEW.json
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: VideoPlayer(_controller
                              ..initialize()
                              ..addListener(() {
                                if (_controller.value.hasError) {
                                  Logger().e("VIDEO PLAYER:");

                                  Logger().e(_controller.value.errorDescription);

                                  showDialog(
                                      context: context,
                                      builder: (_) => new AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                new Text("Live Has Ended"),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    children: [
                                                      FlatButton(
                                                        child: Text('EXIT'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            actions: <Widget>[],
                                          )).then(
                                      (value) => Navigator.pop(context));
                                }
                              })
                              ..play().catchError((onError) {
                                Logger().e("VIDEO PLAYER ERROR:$onError");
                                if (_controller.value.hasError) {}
                              })))),
                  ),
                  BlocBuilder<LiveStreamBloc, LiveStreamStates>(
                      builder: (context, state) {
                    if (state is JoinLiveSuccess) {
                      return StreamBuilder<bool>(
                          stream: productsVisibility,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            if (snapshot.data != null && snapshot.data)
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 500,
                                  child: ListView.builder(
                                      itemCount:
                                          state.liveResponse.products.length,
                                      padding: EdgeInsets.all(0),
                                      itemBuilder: (BuildContext context,
                                              int index) =>
                                          GestureDetector(
                                            onTap: () {
                                              if (checkoutPanelController
                                                  .isPanelOpen)
                                                checkoutPanelController.close();
                                              else {
                                                BlocProvider.of<
                                                            LiveStreamCheckoutBloc>(
                                                        context)
                                                    .add(ShowProduct(state
                                                        .liveResponse
                                                        .products[index]));
                                                addToCartPanelController.open();
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Container(
                                                  height: 90,
                                                  width: 80,
                                                  child:
                                                      FadeInImage.memoryNetwork(
                                                    image: state
                                                        .liveResponse
                                                        .products[index]
                                                        .thumbnail,
                                                    height: 90,
                                                    width: 80,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        kTransparentImage,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                ),
                              );
                            else
                              return Container();
                          });
                    } else
                      return Container();
                  }),
                  StreamBuilder<bool>(
                      stream: realTimeController.liveReaction,
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.data != null && snapshot.data)
                          return Positioned(
                            bottom: 20,
                            right: 4,
                            child:    Container(
                              alignment: Alignment.bottomRight,
                              width: 200,
                              height: 500,
                              child: FlareActor("assets/images/test.flr",
                                  fit: BoxFit.contain,
                                  sizeFromArtboard: true,
                                  shouldClip: true,
                                  snapToEnd: true, callback: (value) {
                                    print("HEART ANIMATION END: $value");
                                  },
                                  alignment: Alignment.bottomRight,
                                  animation: "Start"),
                            ),

//                          Lottie.network(
//                              'https://assets4.lottiefiles.com/packages/lf20_sXVZLv.json',
//                            animate: true,
//                            repeat: false,
//
//
//                            alignment: Alignment.bottomRight,
//                            height: 500,
//                            width: 50
//                          ),


                          );
                        else
                          return Container();
                      }),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 20,
                              child: IconButton(
                                constraints:
                                    BoxConstraints.tight(Size.square(40)),
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  productsVisibility
                                      .add(!productsVisibility.value);
                                },
                                icon: Icon(
                                  FontAwesomeIcons.box,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              constraints: BoxConstraints.tight(Size.square(40)),
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                realTimeController
                                    .showLiveReaction(widget.presenter.id);
                              },
                              icon: Icon(
                                FontAwesomeIcons.heart,
                                size: 16,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                        width: 3 * MediaQuery.of(context).size.width / 4,
                        child: LiveCommentBox(widget.presenter.id)),
                  ),
                  SlidingUpPanel(
                      maxHeight: 260,
                      backdropTapClosesPanel: true,
                      defaultPanelState: PanelState.CLOSED,
                      minHeight: 0,
                      controller: addToCartPanelController,
                      panel: AddToCartPopUp(context, (value) {
                        if (value) addToCartPanelController.close();
                      })),
                  SlidingUpPanel(
                      maxHeight: 320,
                      backdropTapClosesPanel: true,
                      defaultPanelState: PanelState.CLOSED,
                      minHeight: 0,
                      controller: checkoutPanelController,
                      panel: CartCheckOutPopUp(context)),
                ],
              );
            } else
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              );
          })),
    );
  }
}

class BurstController extends FlareController {
  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    //print("BURST CONTROLLER ADVANCE  : ${artboard.} ");
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    print("BURST CONTROLLER : INITIALISED IS CALLED");
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
    print("BURST CONTROLLER : INITIALISED IS CALLED");
  }
}
