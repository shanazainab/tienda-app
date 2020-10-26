import 'dart:ui';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/loading-events.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/events/review-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/review-bloc.dart';
import 'package:tienda/bloc/single-product-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/loading-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/product-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/model/wishlist.dart';
import 'package:tienda/video-overlays/constants.dart';
import 'package:tienda/video-overlays/overlay_handler.dart';
import 'package:tienda/view/cart/page/cart-page.dart';
import 'package:tienda/view/live-stream/widget/products/product-description-tab.dart';
import 'package:tienda/view/products/customer-reviews-rating-tab.dart';
import 'package:tienda/view/products/presenter-info-container.dart';
import 'package:tienda/view/products/product-info-container.dart';
import 'package:tienda/view/products/video/product-video-downloader.dart';
import 'package:tienda/view/widgets/loading-widget.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

class VideoControl {
  bool isPlaying;
  bool showControl;

  VideoControl(this.isPlaying, this.showControl);
}

class ProductVideoPage extends StatefulWidget {
  final int productId;

  ProductVideoPage(this.productId);

  @override
  _ProductVideoPageState createState() => _ProductVideoPageState();
}

class _ProductVideoPageState extends State<ProductVideoPage> {
  SingleProductBloc singleProductBloc = new SingleProductBloc();

  ReviewBloc reviewBloc = new ReviewBloc();

  final addToCartStream = new BehaviorSubject<bool>();
  final videoplayerControlStream = new BehaviorSubject<VideoControl>();

  ScrollController scrollController = new ScrollController();
  VideoPlayerController _controller;

  double aspectRatio = 3 / 2;

  final playPauseStatus = new BehaviorSubject<String>();

  @override
  void dispose() {
    _controller.dispose();
    videoplayerControlStream.drain();
    playPauseStatus.drain();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    playPauseStatus.sink.add("PLAY");
    videoplayerControlStream.sink.add(VideoControl(true, true));
    singleProductBloc.add(FetchProductDetails(productId: widget.productId));

    addToCartStream.listen((value) {
      if (value != null && value) {
        OverlayEntry entry;
        entry = OverlayEntry(
            builder: (context) => new AlertDialog(
                  contentPadding: EdgeInsets.all(8),
                  title: Center(child: new Text("Item Added to Cart")),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          OutlineButton(
                              color: Colors.black,
                              borderSide: BorderSide(color: Colors.black),
                              onPressed: () {
                                entry.remove();
                              },
                              child: Text('Continue Shopping')),
                          OutlineButton(
                            child: Text('CheckOut'),
                            color: Colors.black,
                            borderSide: BorderSide(color: Colors.black),
                            onPressed: () {
                              entry.remove();

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return CartPage();
                                }),
                              );
                              _controller.pause();

                              Provider.of<OverlayHandlerProvider>(context,
                                      listen: false)
                                  .removeOverlay(context);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                  actions: <Widget>[],
                ));
        Overlay.of(context).insert(entry);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartStates>(
      listener: (context, state) {
        if (state is LoadCartSuccess) {
          BlocProvider.of<LoadingBloc>(context)..add(StopLoading());
          addToCartStream.sink.add(true);
        }
        if (state is EmptyCart)
          BlocProvider.of<LoadingBloc>(context)..add(StopLoading());
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ReviewBloc>(
            create: (BuildContext context) => reviewBloc,
          ),
          BlocProvider(
            create: (BuildContext context) => singleProductBloc,
          ),
        ],
        child: Scaffold(
          body: BlocBuilder<SingleProductBloc, ProductStates>(
              builder: (context, state) {
            if (state is FetchProductDetailsSuccess) {
              _controller =
                  VideoPlayerController.network(state.product.lastVideo)
                    ..initialize()
                    ..play();

              return Consumer<OverlayHandlerProvider>(
                  builder: (context, overlayProvider, _) {
                aspectRatio = !overlayProvider.inPipMode
                    ? MediaQuery.of(context).size.width /
                        MediaQuery.of(context).size.height
                    : (3 / 2);
                return Container(
                  color: Colors.white,
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    physics: !overlayProvider.inPipMode &&
                            !overlayProvider.inFullScreenMode
                        ? ScrollPhysics()
                        : NeverScrollableScrollPhysics(),

                    //   mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (!overlayProvider.inPipMode)
                        SizedBox(
                          height: 32.0,
                        ),
                      buildProductVideo(state.product),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            if (!overlayProvider.inPipMode &&
                                !overlayProvider.inFullScreenMode)
                              buildProductVideoReactions(state.product),
                            if (!overlayProvider.inPipMode &&
                                !overlayProvider.inFullScreenMode)
                              buildProductDetails(state.product),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              });
            }
            return Container(
              child: Center(
                child: spinKit,
              ),
            );
          }),
        ),
      ),
    );
  }

  buildProductVideoReactions(Product product) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
        left: 16.0,
        right: 16,
      ),
      child: Row(
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
                  "1.2k",
                  style: TextStyle(fontSize: 13, color: Color(0xFF1a1824)),
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/svg/livechat.svg",
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Comments",
                    style: TextStyle(fontSize: 13, color: Color(0xFF1a1824)),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/svg/share.svg",
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Share",
                    style: TextStyle(fontSize: 13, color: Color(0xFF1a1824)),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                ProductVideoDownloader(product),
                Text(
                  "Save",
                  style: TextStyle(fontSize: 13, color: Color(0xFF1a1824)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  buildProductVideo(Product product) {
    return Consumer<OverlayHandlerProvider>(
        builder: (context, overlayProvider, _) {
      if (overlayProvider.inPipMode) {
      } else {}
      return Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    videoplayerControlStream.sink.add(VideoControl(
                        videoplayerControlStream.value.isPlaying,
                        !videoplayerControlStream.value.showControl));
                  },
                  child: RotatedBox(
                    quarterTurns: !overlayProvider.inFullScreenMode ? 0 : 1,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      // width: overlayProvider.inPipMode
                      //     ? (Constants.VIDEO_TITLE_HEIGHT_PIP * aspectRatio)
                      //     : MediaQuery.of(context).size.width,
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
                      color: Colors.black,
                      child: AspectRatio(
                          aspectRatio: aspectRatio,
                          child: VideoPlayer(
                            _controller,
                          )),
                    ),
                  ),
                ),
              ),
              if (overlayProvider.inPipMode)
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Provider.of<OverlayHandlerProvider>(context,
                              listen: false)
                          .disablePip();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            product.nameEn,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (overlayProvider.inPipMode)
                StreamBuilder<String>(
                    stream: playPauseStatus,
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return IconButton(
                        icon: Icon(
                          snapshot.data != null && snapshot.data == "PLAY"
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: () {
                          if (_controller.value.isPlaying) {
                            playPauseStatus.sink.add("PAUSE");
                            _controller.pause();
                          } else {
                            playPauseStatus.sink.add("PLAY");

                            _controller.play();
                          }
                        },
                      );
                    }),
              if (overlayProvider.inPipMode)
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _controller.pause();

                    Provider.of<OverlayHandlerProvider>(context, listen: false)
                        .removeOverlay(context);
                  },
                )
            ],
          ),
          if (!overlayProvider.inPipMode)
            StreamBuilder<VideoControl>(
                stream: videoplayerControlStream,
                builder: (BuildContext context,
                    AsyncSnapshot<VideoControl> snapshot) {
                  if (snapshot.hasData)
                    return videoPlayerOverlayWidgets(
                        snapshot.data, overlayProvider);
                  else
                    return Container();
                }),
        ],
      );
    });
  }

  buildProductDetails(Product product) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 0, bottom: 100),
        controller: scrollController,
        children: [
          ProductInfoContainer(product),
          product.images.isNotEmpty
              ? Container(
                  color: Colors.white,
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: product.images.length,
                        itemBuilder: (BuildContext context, int index) =>
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: FadeInImage.memoryNetwork(
                                  image: product.images[index],
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  placeholder: kTransparentImage,
                                ),
                              ),
                            )),
                  ),
                )
              : Container(),
          BlocBuilder<SingleProductBloc, ProductStates>(
              builder: (context, state) {
            if (state is FetchProductDetailsSuccess) {
              // FirebaseAnalytics().logEvent(name: "VIDEO_VIEW", parameters: {
              //   'presenter_name': state.product.presenter.name,
              //   'category_name': state.product.presenter.categoryId,
              //   'video_name': state.product.nameEn
              // });

              return Consumer<OverlayHandlerProvider>(
                  builder: (context, overlayProvider, _) {
                if (!overlayProvider.inPipMode)
                  return Row(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          ///ADD TO WISHLIST
                          BlocProvider.of<WishListBloc>(context).add(
                              AddToWishList(
                                  wishListItem: new WishListItem(
                                      product: state.product)));
                        },
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('wishlist')
                              .toUpperCase(),
                          style: TextStyle(color: Color(0xff50C0A8)),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(child: BlocBuilder<LoadingBloc, LoadingStates>(
                          builder: (context, loadingState) {
                        if (loadingState is AppLoading)
                          return RaisedButton(
                            onPressed: () {
                              //do nothing
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        else
                          return RaisedButton(
                              onPressed: () {
                                BlocProvider.of<LoadingBloc>(context)
                                  ..add(StartLoading());

                                state.product.quantity = 1;
                                BlocProvider.of<CartBloc>(context).add(
                                    AddCartItem(
                                        isFromLiveStream: false,
                                        cartItem: state.product,
                                        isLoggedIn:
                                            !(BlocProvider.of<LoginBloc>(
                                                context) is GuestUser)));
                              },
                              child: Text(AppLocalizations.of(context)
                                  .translate('add-to-cart')
                                  .toUpperCase()));
                      })),
                      SizedBox(
                        width: 8,
                      )
                    ],
                  );
                else
                  return Container(
                    height: 0,
                  );
              });
            } else
              return Container(
                height: 0,
              );
          }),
          product.presenter.id != null
              ? Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    PresenterInfoContainer(product.presenter),
                  ],
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.coins,
                  color: Color(0xff008c84),
                  size: 10,
                ),
                SizedBox(
                  width: 2,
                ),
                Text(
                  'Earn 532 tienda Points',
                  style: TextStyle(
                    color: Color(0xff008c84),
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ProductDescriptionTab(product, (pageOffset) {}),
          SizedBox(
            height: 10,
          ),
          (!product.isReviewed && product.isPurchased) ||
                  product.reviews.isNotEmpty
              ? BlocProvider(
                  create: (BuildContext context) =>
                      ReviewBloc()..add(LoadReview(product.reviews)),
                  child: CustomerReviewRatingTab(product),
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Future<void> shareProductDetails() async {
    ///create dynamic link for referral
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://l.tienda.ae/l',
      link: Uri.parse('https://tienda.ae/review/${widget.productId}'),
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
        subject: "Check out this cool product review in Tienda !!",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  videoPlayerOverlayWidgets(
      VideoControl videoControl, OverlayHandlerProvider overlayProvider) {
    return GestureDetector(
      onTap: () {
        videoplayerControlStream.sink.add(
            VideoControl(videoControl.isPlaying, !videoControl.showControl));
      },
      child: Visibility(
        visible: videoControl.showControl,
        child: RotatedBox(
          quarterTurns: !overlayProvider.inFullScreenMode ? 0 : 1,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            // width: overlayProvider.inPipMode
            //     ? (Constants.VIDEO_TITLE_HEIGHT_PIP * aspectRatio)
            //     : MediaQuery.of(context).size.width,
            width: overlayProvider.inPipMode
                ? (Constants.VIDEO_TITLE_HEIGHT_PIP * aspectRatio)
                : overlayProvider.inFullScreenMode
                    ? MediaQuery.of(context).size.height -
                        MediaQuery.of(context).viewPadding.bottom
                    : MediaQuery.of(context).size.width,
            height: overlayProvider.inPipMode
                ? Constants.VIDEO_TITLE_HEIGHT_PIP
                : overlayProvider.inFullScreenMode
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.height * 32 / 100,
            color: Colors.black.withOpacity(0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                overlayProvider.inFullScreenMode
                    ? Container()
                    : Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 30,
                              ),
                              color: Colors.white,
                              onPressed: () {
                                Provider.of<OverlayHandlerProvider>(context,
                                        listen: false)
                                    .enablePip(aspectRatio);
                              }),
                          // IconButton(
                          //   padding: EdgeInsets.zero,
                          //   icon: Icon(
                          //     Icons.share,
                          //     size: 30,
                          //     color: Colors.white,
                          //   ),
                          //   onPressed: () {
                          //     shareProductDetails();
                          //   },
                          // ),
                        ],
                      ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: videoControl.isPlaying
                            ? Icon(Icons.pause)
                            : Icon(Icons.play_arrow),
                        color: Colors.white,
                        onPressed: () {
                          videoplayerControlStream.sink.add(VideoControl(
                              videoControl.isPlaying,
                              !videoControl.showControl));
                          if (videoControl.isPlaying) {
                            videoplayerControlStream.sink.add(
                                VideoControl(false, !videoControl.showControl));
                          } else {
                            videoplayerControlStream.sink.add(
                                VideoControl(true, !videoControl.showControl));
                          }
                        }),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.fullscreen,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        !overlayProvider.inFullScreenMode
                            ? Provider.of<OverlayHandlerProvider>(context,
                                    listen: false)
                                .enableFullScreen(aspectRatio)
                            : Provider.of<OverlayHandlerProvider>(context,
                                    listen: false)
                                .disableFullScreen();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
