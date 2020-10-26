import 'package:chewie/chewie.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tienda/bloc/bottom-nav-bar-bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/bottom-nav-bar-events.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/events/live-events.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/events/loading-events.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/live-contents-bloc.dart';
import 'package:tienda/bloc/live-stream-bloc.dart';
import 'package:tienda/bloc/live-stream-checkout-bloc.dart';
import 'package:tienda/bloc/live-stream-product-bloc.dart';
import 'package:tienda/bloc/live-stream-product-details-bloc.dart';
import 'package:tienda/bloc/live-stream-review-bloc.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/live-states.dart';
import 'package:tienda/bloc/states/live-stream-states.dart';
import 'package:tienda/bloc/states/loading-states.dart';
import 'package:tienda/bloc/states/product-states.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/model/live-reaction.dart';
import 'package:tienda/model/live-response.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/video-overlays/overlay_handler.dart';
import 'package:tienda/view/live-stream/widget/cart/live-stream-cart-container.dart';
import 'package:tienda/view/live-stream/widget/chat/live-chat-panel.dart';
import 'package:tienda/view/live-stream/widget/checkout/checkout-panel.dart';
import 'package:tienda/view/live-stream/widget/contents/live-stream-review-container.dart';
import 'package:tienda/view/live-stream/widget/contents/live-videos-list.dart';
import 'package:tienda/view/live-stream/widget/contents/presenter-profile-card.dart';
import 'package:tienda/view/live-stream/widget/contents/related-brand-products.dart';
import 'package:tienda/view/live-stream/widget/contents/thank-you-note.dart';
import 'package:tienda/view/live-stream/widget/notification/product-mention-page.dart';
import 'package:tienda/view/live-stream/widget/player/live-stream-video-player.dart';
import 'package:tienda/view/live-stream/widget/products/live-product-details.dart';
import 'package:video_player/video_player.dart';

import '../widget/products/live-products.dart';

class LiveStreamScreen extends StatefulWidget {
  final Presenter presenter;

  LiveStreamScreen(this.presenter);

  @override
  _LiveStreamScreenState createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  PanelController cartPanelController = new PanelController();
  PanelController productMentionController = new PanelController();

  RealTimeController realTimeController = new RealTimeController();
  double aspectRatio;
  PanelController liveChatPanelController = new PanelController();
  PanelController liveProductsPanelController = new PanelController();

  PanelController checkoutPanelController = new PanelController();

  final productsVisibility = BehaviorSubject<bool>();
  VideoPlayerController _controller;

  LiveContentsBloc liveContentsBloc = new LiveContentsBloc();

  final FocusNode textFocusNode = new FocusNode();

  ScrollController scrollController = new ScrollController();
  TextEditingController textEditingController = new TextEditingController();
  LiveStreamReviewBloc liveStreamReviewBloc = new LiveStreamReviewBloc();

  ChewieController _chewieController;
  ProductBloc productBloc = new ProductBloc();

  @override
  void dispose() {
    _controller.dispose();
    realTimeController.disposeLiveSubjectStreams();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    liveContentsBloc.add(LoadCurrentLiveVideoList());
    liveStreamReviewBloc.add(GetReviews(widget.presenter.id));
    new RealTimeController().emitJoinLive(widget.presenter.id);

    productsVisibility.add(false);
    _controller = VideoPlayerController.network(widget.presenter.m3U8Url)
      ..initialize()
      ..play();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        scrollController.animateTo(scrollController.position.pixels + 100,
            duration: Duration(milliseconds: 400), curve: Curves.easeIn);
      },
    );
    realTimeController.liveReaction.listen((value) async {
      if (value.showReaction) {
        await Future.delayed(const Duration(seconds: 3));
        realTimeController.stopLiveReaction();
      }
    });
    realTimeController.mentionedProductStream.listen((value) {
      BlocProvider.of<BottomNavBarBloc>(context)
          .add(ChangeBottomNavBarState(-1, true));
      productMentionController.open();
    });
  }

  @override
  Widget build(BuildContext contextA) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CartBloc, CartStates>(
          listener: (context, state) {
            if (state is LoadCartSuccess)
              BlocProvider.of<LoadingBloc>(context).add(StopLoading());
          },
        ),
        BlocListener<LiveStreamBloc, LiveStreamStates>(
            listener: (context, state) {
          if (state is JoinLiveSuccess) {
            BlocProvider.of<CartBloc>(context).add(FetchCartData());

            productBloc.add(
                FetchProductList(query: state.liveResponse.products[1].brand));
            BlocProvider.of<LiveStreamProductBloc>(context)
                .add(UpdateWishListProducts(state.liveResponse.products));
          }
        })
      ],
      child: BlocBuilder<LiveStreamBloc, LiveStreamStates>(
          builder: (context, state) {
        if (state is JoinLiveSuccess) {
          return Consumer<OverlayHandlerProvider>(
              builder: (context, overlayProvider, _) {
            aspectRatio = !overlayProvider.inPipMode
                ? MediaQuery.of(context).size.width /
                    MediaQuery.of(context).size.height
                : (3 / 2);
            return Scaffold(
              resizeToAvoidBottomPadding: false,
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: BlocBuilder<LoadingBloc, LoadingStates>(
                  builder: (context, loadingState) {
                if (loadingState is AppLoading)
                  return LinearProgressIndicator();
                else
                  return Container(
                    height: 0,
                  );
              }),
              appBar: !overlayProvider.inPipMode &&
                      !overlayProvider.inFullScreenMode
                  ? AppBar(
                      leading: IconButton(
                          icon: Icon(Icons.keyboard_arrow_down),
                          color: Colors.black,
                          onPressed: () {
                            Provider.of<OverlayHandlerProvider>(context,
                                    listen: false)
                                .enablePip(aspectRatio);
                          }),
                      centerTitle: false,
                      title: PresenterProfileCard(
                          widget.presenter, state.liveResponse.isFollowed))
                  : PreferredSize(
                      child: Container(
                        height: 0,
                      ),
                      preferredSize: Size.fromHeight(0),
                    ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        LiveStreamVideoPlayer(
                            aspectRatio: aspectRatio, controller: _controller),
                        if (!overlayProvider.inPipMode &&
                            !overlayProvider.inFullScreenMode)
                          Container(
                              height:
                                  MediaQuery.of(context).size.height * 60 / 100,
                              child: _liveStreamContents(state.liveResponse)),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !overlayProvider.inPipMode,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SlidingUpPanel(
                        margin: EdgeInsets.all(0),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            topLeft: Radius.circular(12)),

                        /// maxHeight: MediaQuery.of(context).size.height * 60 / 100,
                        backdropTapClosesPanel: true,
                        // margin: EdgeInsets.only(bottom: 70),
                        defaultPanelState: PanelState.CLOSED,
                        minHeight: 0,
                        controller: liveChatPanelController,
                        panel: LiveChatPanel(
                          presenter: widget.presenter,
                          closePanel: (value) {
                            if (value) liveChatPanelController.close();
                          },
                          liveResponse: state.liveResponse,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !overlayProvider.inPipMode,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SlidingUpPanel(
                        margin: EdgeInsets.all(0),

                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            topLeft: Radius.circular(12)),

                        /// maxHeight: MediaQuery.of(context).size.height * 60 / 100,
                        backdropTapClosesPanel: true,
                        //  margin: EdgeInsets.only(bottom: 70),
                        defaultPanelState: PanelState.CLOSED,
                        minHeight: 0,
                        controller: liveProductsPanelController,
                        panel: LiveProductDetails(widget.presenter, (value) {
                          liveProductsPanelController.close();
                          BlocProvider.of<BottomNavBarBloc>(context)
                              .add(ChangeBottomNavBarState(-1, false));
                        }),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !overlayProvider.inPipMode,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SlidingUpPanel(
                        margin: EdgeInsets.all(0),

                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            topLeft: Radius.circular(12)),

                        /// maxHeight: MediaQuery.of(context).size.height * 60 / 100,
                        backdropTapClosesPanel: true,
                        //  margin: EdgeInsets.only(bottom: 70),
                        defaultPanelState: PanelState.CLOSED,
                        minHeight: 0,
                        controller: cartPanelController,
                        panel: LiveStreamCartContainer(
                          onCartClose: () {
                            cartPanelController.close();
                            BlocProvider.of<BottomNavBarBloc>(context)
                                .add(ChangeBottomNavBarState(-1, false));
                          },
                          onProceedToCheckout: () {
                            checkoutPanelController.open();
                          },
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !overlayProvider.inPipMode,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SlidingUpPanel(
                        margin: EdgeInsets.all(0),

                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            topLeft: Radius.circular(12)),

                        /// maxHeight: MediaQuery.of(context).size.height * 60 / 100,
                        backdropTapClosesPanel: true,
                        //  margin: EdgeInsets.only(bottom: 70),
                        defaultPanelState: PanelState.CLOSED,
                        minHeight: 0,
                        controller: productMentionController,
                        panel: BlocProvider(
                          create: (context) => CheckOutBloc()
                            ..add(DoCartCheckoutProgressUpdate(
                              checkOutStatus: 'CART',
                              fromLiveStream: true,
                              presenterId: widget.presenter.id,
                            )),
                          child: ProductMentionPage(
                            liveProducts: state.liveResponse.products,
                            onProductTap: (productIndex) {
                              productMentionController.close();
                              BlocProvider.of<LiveStreamProductDetailsBloc>(
                                      context)
                                  .add(ShowProduct(state
                                      .liveResponse.products[productIndex]));
                              BlocProvider.of<BottomNavBarBloc>(context)
                                  .add(ChangeBottomNavBarState(-1, true));
                              liveProductsPanelController.open();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !overlayProvider.inPipMode,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SlidingUpPanel(
                        margin: EdgeInsets.all(0),

                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            topLeft: Radius.circular(12)),

                        /// maxHeight: MediaQuery.of(context).size.height * 60 / 100,
                        backdropTapClosesPanel: true,
                        //  margin: EdgeInsets.only(bottom: 70),
                        defaultPanelState: PanelState.CLOSED,
                        minHeight: 0,
                        controller: checkoutPanelController,
                        panel: MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => LiveStreamCheckOutBloc()..add(InitializeLiveStreamCheckout()),
                            ),
                          ],
                          child: CheckoutPanel(
                            presenterId: widget.presenter.id,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          });
        } else
          return Container();
      }),
    );
  }

  Widget _liveStreamContents(LiveResponse liveResponse) {
    return Consumer<OverlayHandlerProvider>(
      builder: (context, overlayProvider, _) {
        if (overlayProvider.inPipMode) return Container();
        return AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: overlayProvider.inPipMode ? 0 : 1,
            child: Stack(
              children: [
                ListView(
                  controller: scrollController,
                  padding: EdgeInsets.only(bottom: 100),

                  shrinkWrap: true,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 14.0, top: 14, right: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            liveResponse.title,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          RaisedButton(
                            color: Colors.white,
                            onPressed: () {
                              BlocProvider.of<BottomNavBarBloc>(context)
                                  .add(ChangeBottomNavBarState(-1, true));
                              cartPanelController.open();
                            },
                            child: Row(
                              children: [
                                Text("Cart",
                                    style: TextStyle(
                                      color: Color(0xff555555),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0,
                                    )),
                                SizedBox(
                                  width: 4,
                                ),
                                SvgPicture.asset(
                                  "assets/svg/shopping-bag-button.svg",
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0, top: 2),
                      child: StreamBuilder<String>(
                          stream: new RealTimeController().viewCountStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(snapshot.data == null
                                  ? "1 watching now"
                                  : "${snapshot.data} watching now"),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/heart.svg",
                            ),
                            StreamBuilder<LiveReaction>(
                                stream: realTimeController.liveReaction,
                                builder: (BuildContext context,
                                    AsyncSnapshot<LiveReaction> snapshot) {
                                  if (snapshot.hasData)
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        snapshot.data.reactionCount.toString(),
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF1a1824)),
                                      ),
                                    );
                                  else
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        liveResponse.reactions.toString(),
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF1a1824)),
                                      ),
                                    );
                                })
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            liveChatPanelController.open();
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/livechat.svg",
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "Live Chat",
                                  style: TextStyle(
                                      fontSize: 13, color: Color(0xFF1a1824)),
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            shareJoinLiveLink();
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/share.svg",
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "Share",
                                  style: TextStyle(
                                      fontSize: 13, color: Color(0xFF1a1824)),
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/download.svg",
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                      fontSize: 13, color: Color(0xFF1a1824)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Divider(
                      color: Color(0xFFc4c4c4),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    LiveProducts(
                        liveResponse: liveResponse,
                        liveProductsPanelController:
                            liveProductsPanelController),
                    SizedBox(
                      height: 42,
                    ),
                    ThankYouNote(
                      presenter: widget.presenter,
                      liveResponse: liveResponse,
                    ),
                    BlocBuilder<LiveStreamReviewBloc, LiveStreamStates>(
                        cubit: liveStreamReviewBloc,
                        builder: (contextA, reviewState) {
                          if (reviewState is GetReviewsSuccess &&
                              reviewState.presenterReviewResponse.info ==
                                  "show review box") {
                            return Padding(
                              padding: const EdgeInsets.only(top: 31.0),
                              child: LiveStreamReviewContainer(
                                  widget.presenter,
                                  reviewState.presenterReviewResponse,
                                  liveStreamReviewBloc),
                            );
                          } else {
                            return Container();
                          }
                        }),
                    Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: BlocBuilder<LiveContentsBloc, LiveStates>(
                            cubit: liveContentsBloc,
                            builder: (context, state) {
                              if (state is LoadCurrentLiveVideoListSuccess &&
                                  state.liveVideos.isNotEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 31.0),
                                  child: LiveVideoList(state.liveVideos),
                                );
                              } else {
                                return Container();
                              }
                            })),
                    SizedBox(
                      height: 42,
                    ),
                    BlocBuilder<ProductBloc, ProductStates>(
                        cubit: productBloc,
                        builder: (context, searchState) {
                          if (searchState is LoadProductListSuccess) {
                            return RelatedBrandProducts(
                                liveResponse.products[1].brand,
                                searchState.productListResponse.products);
                          } else {
                            return Container();
                          }
                        })
                  ],
                ),
              ],
            ));
      },
    );
  }

  Future<void> shareJoinLiveLink() async {
    ///create dynamic link for referral
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://l.tienda.ae/l',
      link: Uri.parse('https://tienda.ae/joinlive/${widget.presenter.id}'),
      androidParameters: AndroidParameters(
        packageName: 'com.tienda.liveshop',
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short),
      iosParameters: IosParameters(
        bundleId: 'com.beuniquegroup.tienda',
      ),
    );

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    final RenderBox box = context.findRenderObject();
    Share.share("$shortUrl",
        subject: "Check out this ongoing Live in Tienda !!",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
