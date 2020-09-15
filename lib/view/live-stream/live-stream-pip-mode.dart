import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/live-stream-bloc.dart';
import 'package:tienda/bloc/live-stream-checkout-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/live-stream-states.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/model/live-chat.dart';
import 'package:tienda/model/live-response.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/video-overlays/constants.dart';
import 'package:tienda/video-overlays/overlay_handler.dart';
import 'package:tienda/view/live-stream/add-to-cart-popup.dart';
import 'package:tienda/view/live-stream/cart-checkout-pop-up.dart';
import 'package:tienda/view/live-stream/live-chat-container.dart';
import 'package:tienda/view/live-stream/live-stream-bottom-bar.dart';
import 'package:tienda/view/live-stream/presenter-profile-card.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

class LiveStreamPIPMode extends StatefulWidget {
  final Presenter presenter;

  LiveStreamPIPMode(this.presenter);

  @override
  _LiveStreamPIPModeState createState() => _LiveStreamPIPModeState();
}

class _LiveStreamPIPModeState extends State<LiveStreamPIPMode> {
  PanelController addToCartPanelController = new PanelController();
  PanelController checkoutPanelController = new PanelController();
  RealTimeController realTimeController = new RealTimeController();
  double aspectRatio;

  final productsVisibility = BehaviorSubject<bool>();
  VideoPlayerController _controller;

  final FocusNode textFocusNode = new FocusNode();

  ScrollController scrollController = new ScrollController();
  TextEditingController textEditingController = new TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    new RealTimeController().emitJoinLive(widget.presenter.id);

    productsVisibility.add(false);
    _controller = VideoPlayerController.network(widget.presenter.streamUrl)
      ..initialize()
      ..play();

    realTimeController.liveReaction.listen((value) async {
      if (value != null && value) {
        await Future.delayed(const Duration(seconds: 3));
        realTimeController.stopLiveReaction();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LiveStreamBloc, LiveStreamStates>(
          builder: (context, state) {
        if (state is JoinLiveSuccess) {
          return Consumer<OverlayHandlerProvider>(
              builder: (context, overlayProvider, _) {
            aspectRatio = !overlayProvider.inPipMode
                ? MediaQuery.of(context).size.width /
                    MediaQuery.of(context).size.height
                : (3 / 2);
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _buildVideoPlayer(),

                if (!overlayProvider.inPipMode)
                  _liveStreamOverlay(state.liveResponse),
              ],
            );
          });
        } else
          return Container();
      }),
    );
  }

  Widget _buildVideoPlayer() {
    return Consumer<OverlayHandlerProvider>(
        builder: (context, overlayProvider, _) {


      return Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              width: overlayProvider.inPipMode
                  ? (Constants.VIDEO_TITLE_HEIGHT_PIP * aspectRatio)
                  : MediaQuery.of(context).size.width,
              height: overlayProvider.inPipMode
                  ? Constants.VIDEO_TITLE_HEIGHT_PIP
                  : MediaQuery.of(context).size.height,
              color: Colors.red,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: VideoPlayer(
                _controller,
              ),
            ),
          ),


          if (overlayProvider.inPipMode)
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  Provider.of<OverlayHandlerProvider>(context, listen: false)
                      .disablePip();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "LIVE",
                  ),
                ),
              ),
            ),
          if (overlayProvider.inPipMode)
            IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              },
            ),
          if (overlayProvider.inPipMode)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Provider.of<OverlayHandlerProvider>(context, listen: false)
                    .removeOverlay(context);
              },
            )
        ],
      );
    });
  }

  Widget _liveStreamOverlay(LiveResponse liveResponse) {
    return Consumer<OverlayHandlerProvider>(
      builder: (context, overlayProvider, _) {
        if (overlayProvider.inPipMode) return Container();
        return AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: overlayProvider.inPipMode ? 0 : 1,
            child: Stack(
              children: [

                Positioned(
                  top:60,
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: Icon(Icons.keyboard_arrow_down),
                                color: Colors.white,
                                onPressed: () {
                                  Provider.of<OverlayHandlerProvider>(context,
                                          listen: false)
                                      .enablePip(aspectRatio);
                                }),
                            PresenterProfileCard(
                                widget.presenter, liveResponse.isFollowed),
                          ],
                        ),
                        Row(
                          children: [
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
                                        state.addedCart.products.length
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white),
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
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white),
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
                              width: 8,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<bool>(
                    stream: productsVisibility,
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.data != null && snapshot.data)
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: 500,
                            child: ListView.builder(
                                itemCount: liveResponse.products.length,
                                padding: EdgeInsets.all(0),
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    GestureDetector(
                                      onTap: () {
                                        if (checkoutPanelController.isPanelOpen)
                                          checkoutPanelController.close();
                                        else {
                                          BlocProvider.of<
                                                      LiveStreamCheckoutBloc>(
                                                  context)
                                              .add(ShowProduct(liveResponse
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
                                            child: CachedNetworkImage(
                                              imageUrl: liveResponse
                                                  .products[index].thumbnail,
                                              height: 90,
                                              width: 80,
                                              fit: BoxFit.cover,

                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                          ),
                        );
                      else
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
                          child: Container(
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
                        );
                      else
                        return Container();
                    }),

                StreamBuilder<List<LiveChat>>(
                    stream: realTimeController.liveChatStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<LiveChat>> snapshot) {
                      if (snapshot.data != null)
                        return Positioned(
                          bottom: 50,
                          left: 4,
                          child: LiveChatContainer(
                            scrollController: scrollController,
                            liveChats: snapshot.data,
                          ),
                        );
                      else
                        return Container();
                    }),

                Align(
                  alignment: Alignment.bottomLeft,
                  child: LiveStreamBottomBar(
                    productsVisibility: productsVisibility,
                    presenter: widget.presenter,
                  ),
                ),

                ///Sliding panels for add to cart and product details

                SlidingUpPanel(
                    maxHeight: 320,
                    backdropTapClosesPanel: true,
                    defaultPanelState: PanelState.CLOSED,
                    minHeight: 0,
                    controller: addToCartPanelController,
                    panel: AddToCartPopUp(context, (value) {
                      if (value) addToCartPanelController.close();
                    },widget.presenter.id)),

                SlidingUpPanel(
                    maxHeight: 3 * MediaQuery.of(context).size.height / 4,
                    backdropTapClosesPanel: true,
                    defaultPanelState: PanelState.CLOSED,
                    minHeight: 0,
                    controller: checkoutPanelController,
                    panel: BlocProvider(
                      create: (context) => CheckOutBloc(),
                      child: CartCheckOutPopUp(context, (value) {
                        checkoutPanelController.close();
                      }, (shouldClose) {
                        if (shouldClose) checkoutPanelController.close();
                      }),
                    )),
              ],
            ));
      },
    );
  }
}
