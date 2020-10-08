import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/follow-events.dart';
import 'package:tienda/bloc/events/live-events.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/events/loading-events.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/follow-bloc.dart';
import 'package:tienda/bloc/live-contents-bloc.dart';
import 'package:tienda/bloc/live-stream-bloc.dart';
import 'package:tienda/bloc/live-stream-product-bloc.dart';
import 'package:tienda/bloc/live-stream-review-bloc.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/follow-states.dart';
import 'package:tienda/bloc/states/live-states.dart';
import 'package:tienda/bloc/states/live-stream-states.dart';
import 'package:tienda/bloc/states/loading-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/product-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/live-response.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/model/wishlist.dart';
import 'package:tienda/video-overlays/constants.dart';
import 'package:tienda/video-overlays/overlay_handler.dart';
import 'package:tienda/view/live-stream/live-chat-panel.dart';
import 'package:tienda/view/live-stream/live-stream-review-container.dart';
import 'package:tienda/view/live-stream/live-videos-list.dart';
import 'package:tienda/view/live-stream/presenter-profile-card.dart';
import 'package:tienda/view/live-stream/related-brand-products.dart';
import 'package:video_player/video_player.dart';

class LiveStreamNewDesign extends StatefulWidget {
  final Presenter presenter;

  LiveStreamNewDesign(this.presenter);

  @override
  _LiveStreamNewDesignState createState() => _LiveStreamNewDesignState();
}

class _LiveStreamNewDesignState extends State<LiveStreamNewDesign> {
  PanelController checkoutPanelController = new PanelController();
  RealTimeController realTimeController = new RealTimeController();
  double aspectRatio;
  PanelController liveChatPanelController = new PanelController();

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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    liveContentsBloc.add(LoadLiveVideoList());
    liveStreamReviewBloc.add(GetReviews(widget.presenter.id));
    new RealTimeController().emitJoinLive(widget.presenter.id);

    productsVisibility.add(false);
    _controller = VideoPlayerController.network(widget.presenter.streamUrl)
      ..initialize()
      ..play();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print("FROM PANEL: $visible");

        scrollController.animateTo(scrollController.position.pixels + 100, duration: Duration(
          milliseconds: 400
        ), curve: Curves.easeIn);
      },
    );
    realTimeController.liveReaction.listen((value) async {
      if (value != null && value) {
        await Future.delayed(const Duration(seconds: 3));
        realTimeController.stopLiveReaction();
      }
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
              body: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    _buildVideoPlayer(),
                    if (!overlayProvider.inPipMode &&
                        !overlayProvider.inFullScreenMode)
                      Container(
                          height: MediaQuery.of(context).size.height * 60 / 100,
                          child: _liveStreamContents(state.liveResponse)),
                  ],
                ),
              ),
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
            child: Stack(
              children: [
                RotatedBox(
                  quarterTurns: !overlayProvider.inFullScreenMode ? 0 : 1,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    width: overlayProvider.inPipMode
                        ? (Constants.VIDEO_TITLE_HEIGHT_PIP * aspectRatio)
                        : overlayProvider.inFullScreenMode
                            ? MediaQuery.of(context).size.height
                            : MediaQuery.of(context).size.width,
                    height: overlayProvider.inPipMode
                        ? Constants.VIDEO_TITLE_HEIGHT_PIP
                        : overlayProvider.inFullScreenMode
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.height * 32 / 100,
                    color: Colors.red,
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: VideoPlayer(
                        _controller,
                      ),
                    ),
                  ),
                ),
                if (!overlayProvider.inPipMode)
                  FutureBuilder(
                    future: Future.delayed(Duration(seconds: 1)),
                    builder: (c, s) => Align(
                      alignment: Alignment.topRight,
                      child: RotatedBox(
                        quarterTurns: !overlayProvider.inFullScreenMode ? 0 : 1,
                        child: Card(
                          margin: EdgeInsets.only(top: 17, right: 11),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(48)),
                          color: !overlayProvider.inFullScreenMode
                              ? Color(0xFFff2e63)
                              : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 4, bottom: 4, left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor:
                                      !overlayProvider.inFullScreenMode
                                          ? Colors.white
                                          : Color(0xFFff2e63),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate("live")
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: !overlayProvider.inFullScreenMode
                                        ? Colors.white
                                        : Color(0xFFff2e63),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (!overlayProvider.inPipMode &&
                    !overlayProvider.inFullScreenMode)
                  Positioned(
                      bottom: 8,
                      right: 8,
                      child: IconButton(
                        onPressed: () {
                          !overlayProvider.inFullScreenMode
                              ? Provider.of<OverlayHandlerProvider>(context,
                                      listen: false)
                                  .enableFullScreen(aspectRatio)
                              : Provider.of<OverlayHandlerProvider>(context,
                                      listen: false)
                                  .disableFullScreen();
                        },
                        icon: Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                        ),
                      )),
                if (!overlayProvider.inPipMode &&
                    overlayProvider.inFullScreenMode)
                  Positioned(
                      bottom: 8,
                      left: 8,
                      child: IconButton(
                        onPressed: () {
                          Provider.of<OverlayHandlerProvider>(context,
                                  listen: false)
                              .disableFullScreen();
                        },
                        icon: Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                        ),
                      ))
              ],
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
                      padding: const EdgeInsets.only(left: 14.0, top: 14),
                      child: Text(
                        "All about hivebox freezer ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                "302",
                                style: TextStyle(
                                    fontSize: 13, color: Color(0xFF1a1824)),
                              ),
                            )
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
                            shareProductDetails();
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
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0, right: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "LIVE PRODUCTS",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${liveResponse.products.length} ITEMS",
                            style: TextStyle(
                                fontSize: 13, color: Color(0xFF555555)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: liveResponse.products.length,
                        itemBuilder: (BuildContext context, int index) =>
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    border: Border.all(
                                        color:
                                            Color.fromRGBO(96, 97, 112, 0.08))),
                                width: MediaQuery.of(context).size.width - 16,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 96,
                                      child: CachedNetworkImage(
                                        imageUrl: liveResponse
                                            .products[index].thumbnail,
                                        height: 100,
                                        width: 96,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              liveResponse
                                                  .products[index].nameEn,
                                              softWrap: true,
                                              style: TextStyle(),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    RatingBar(
                                                      initialRating:
                                                          liveResponse
                                                              .products[index]
                                                              .overallRating,
                                                      minRating: 1,
                                                      itemSize: 20,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0.5),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color:
                                                            Color(0xFFf9d572),
                                                        size: 14,
                                                      ),
                                                      // onRatingUpdate:
                                                      //     (rating) {
                                                      //   print(rating);
                                                      // },
                                                    ),
                                                    Text(liveResponse
                                                        .products[index]
                                                        .totalReviews
                                                        .toString())
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: BlocBuilder<
                                                          LiveStreamProductBloc,
                                                          LiveStreamStates>(
                                                      builder:
                                                          (context, state) {
                                                    if (state
                                                            is UpdateWishListProductsSuccess &&
                                                        state.products[index]
                                                                .isWishListed !=
                                                            null &&
                                                        state.products[index]
                                                            .isWishListed)
                                                      return GestureDetector(
                                                        onTap: () {
                                                          state.products[index]
                                                                  .isWishListed =
                                                              false;
                                                          BlocProvider.of<
                                                                      LiveStreamProductBloc>(
                                                                  context)
                                                              .add(UpdateWishListProducts(
                                                                  state
                                                                      .products));
                                                        },
                                                        child: SvgPicture.asset(
                                                            "assets/svg/heart.svg",
                                                            color: Color(
                                                                0xFFff2e63)),
                                                      );
                                                    else if (state
                                                            is UpdateWishListProductsSuccess &&
                                                        (state.products[index]
                                                                    .isWishListed ==
                                                                null ||
                                                            state
                                                                        .products[
                                                                            index]
                                                                        .isWishListed !=
                                                                    null &&
                                                                !state
                                                                    .products[
                                                                        index]
                                                                    .isWishListed))
                                                      return GestureDetector(
                                                        onTap: () {
                                                          BlocProvider.of<
                                                                      WishListBloc>(
                                                                  context)
                                                              .add(AddToWishList(
                                                                  wishListItem:
                                                                      new WishListItem(
                                                                          product:
                                                                              liveResponse.products[index])));

                                                          state.products[index]
                                                                  .isWishListed =
                                                              true;
                                                          BlocProvider.of<
                                                                      LiveStreamProductBloc>(
                                                                  context)
                                                              .add(UpdateWishListProducts(
                                                                  state
                                                                      .products));
                                                        },
                                                        child: SvgPicture.asset(
                                                          "assets/svg/heart.svg",
                                                        ),
                                                      );
                                                    else
                                                      return Container();
                                                  }),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 11,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Column(
                                                  children: [
                                                    Visibility(
                                                        visible: false,
                                                        child: Text(
                                                            "AED ${liveResponse.products[index].price}")),
                                                    Text(
                                                      "AED ${liveResponse.products[index].price}",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                              0xFFc30045)),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: SizedBox(
                                                      width: 94,
                                                      height: 32,
                                                      child: RaisedButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                  LoadingBloc>(
                                                              context)
                                                            ..add(
                                                                StartLoading());

                                                          liveResponse
                                                              .products[index]
                                                              .quantity = 1;
                                                          BlocProvider.of<
                                                                      CartBloc>(
                                                                  context)
                                                              .add(AddCartItem(
                                                                  isFromLiveStream:
                                                                      false,
                                                                  cartItem:
                                                                      liveResponse
                                                                              .products[
                                                                          index],
                                                                  isLoggedIn: !(BlocProvider.of<
                                                                              LoginBloc>(
                                                                          context)
                                                                      is GuestUser)));
                                                        },
                                                        color:
                                                            Color(0xFF50c0a8),
                                                        child: Text(
                                                          "Add to Cart",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Gotham',
                                                              color: Color(
                                                                  0xFFf6f6f6),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                    SizedBox(
                      height: 42,
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: CachedNetworkImageProvider(
                            "${GlobalConfiguration().getString("imageURL")}/${widget.presenter.profilePicture}"),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Center(
                      child: Text("Thank you for watching.",
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Center(
                      child: Text(widget.presenter.name,
                          style: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 13,
                          )),
                    ),
                    SizedBox(
                      height: 19,
                    ),
                    Center(
                      child: ButtonTheme(
                          height: 32,
                          child: BlocBuilder<FollowBloc, FollowStates>(
                              builder: (context, followState) {
                            if (followState is ChangeFollowStatusSuccess) {
                              return RaisedButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 4, bottom: 4),
                                color: Color(0xffeef2f3),
                                onPressed: () {
                                  BlocProvider.of<FollowBloc>(context).add(
                                      ChangeFollowStatus(widget.presenter.id));
                                },
                                child: followState.isFollowing
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Following".toUpperCase(),
                                            style: TextStyle(
                                                color: Color(0xff282828),
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(
                                            Icons.check,
                                            color: Color(0xff282828),
                                            size: 12,
                                          )
                                        ],
                                      )
                                    : Text(
                                        AppLocalizations.of(context)
                                            .translate("follow")
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: Color(0xff282828),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                              );
                            } else
                              return RaisedButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 4, bottom: 4),
                                color: Color(0xffeef2f3),
                                onPressed: () {
                                  BlocProvider.of<FollowBloc>(context).add(
                                      ChangeFollowStatus(widget.presenter.id));
                                },
                                child: liveResponse.isFollowed
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Following".toUpperCase(),
                                            style: TextStyle(
                                                color: Color(0xff282828),
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(
                                            Icons.check,
                                            color: Color(0xff282828),
                                            size: 12,
                                          )
                                        ],
                                      )
                                    : Text(
                                        AppLocalizations.of(context)
                                            .translate("follow")
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: Color(0xff282828),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                              );
                          })),
                    ),
                    BlocBuilder<LiveStreamReviewBloc, LiveStreamStates>(
                        cubit: liveStreamReviewBloc,
                        builder: (contextA, reviewState) {
                          if (reviewState is GetReviewsSuccess &&
                              reviewState.presenterReviewResponse.info ==
                                  "show review box") {
                            return Padding(
                              padding: const EdgeInsets.only(top:31.0),
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
                              if (state is LoadLiveVideoListSuccess &&
                                  state.liveContents.isNotEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(top:31.0),
                                  child: LiveVideoList(state.liveContents),
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SlidingUpPanel(
                    /// maxHeight: MediaQuery.of(context).size.height * 60 / 100,
                    backdropTapClosesPanel: true,
                    //  margin: EdgeInsets.only(bottom: 70),
                    defaultPanelState: PanelState.CLOSED,
                    minHeight: 0,
                    controller: liveChatPanelController,
                    panel: LiveChatPanel(
                      presenter: widget.presenter,
                      closePanel: (value) {
                        if (value) liveChatPanelController.close();
                      },
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  Future<void> shareProductDetails() async {
    ///create dynamic link for referral
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://beuniquegroup.page.link/amTC',
      link: Uri.parse('https://tienda.ae/'),
      androidParameters: AndroidParameters(
        packageName: 'com.beuniquegroup.tienda',
      ),
      iosParameters: IosParameters(
        bundleId: 'com.beuniquegroup.tienda',
      ),
    );

    final Uri dynamicUrl = await parameters.buildUrl();

    final RenderBox box = context.findRenderObject();
    Share.share("$dynamicUrl",
        subject: "Check Out this product in Tienda !!",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
