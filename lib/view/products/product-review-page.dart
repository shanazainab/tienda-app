import 'dart:isolate';
import 'dart:ui';
import 'dart:io' show Platform;

import 'package:chewie/chewie.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
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
import 'package:tienda/loading-widget.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/model/wishlist.dart';
import 'package:tienda/video-overlays/constants.dart';
import 'package:tienda/video-overlays/overlay_handler.dart';
import 'package:tienda/view/checkout/checkout-orders-main-page.dart';
import 'package:tienda/view/products/add-customer-review-container.dart';
import 'package:tienda/view/products/customer-overall-rating-block.dart';
import 'package:tienda/view/products/customer-reviews-container.dart';
import 'package:tienda/view/products/presenter-info-container.dart';
import 'package:tienda/view/products/product-description-container.dart';
import 'package:tienda/view/products/product-info-container.dart';
import 'package:tienda/view/products/product-video-downloader.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

class ProductReviewPage extends StatefulWidget {
  final int productId;

  ProductReviewPage(this.productId);

  @override
  _ProductReviewPageState createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  SingleProductBloc singleProductBloc = new SingleProductBloc();

  ReviewBloc reviewBloc = new ReviewBloc();

  final addToCartStream = new BehaviorSubject<bool>();

  ScrollController scrollController = new ScrollController();
  VideoPlayerController _controller;

  ChewieController chewieController;
  double aspectRatio = 3 / 2;

  final playPauseStatus = new BehaviorSubject<String>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    playPauseStatus.sink.add("PLAY");

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
                                  return BlocProvider(
                                    create: (context) => CheckOutBloc(),
                                    child: CheckoutOrdersMainPage(),
                                  );
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
          // bottomNavigationBar: SafeArea(
          //   child: BlocBuilder<SingleProductBloc, ProductStates>(
          //       builder: (context, state) {
          //     if (state is FetchProductDetailsSuccess) {
          //
          //       FirebaseAnalytics()
          //           .logEvent(name: "VIDEO_VIEW", parameters: {
          //       'presenter_name':state.product.presenter.name,
          //       'category_name':state.product.presenter.categoryId,
          //       'video_name':state.product.nameEn
          //       });
          //
          //
          //       return Consumer<OverlayHandlerProvider>(
          //           builder: (context, overlayProvider, _) {
          //         if (!overlayProvider.inPipMode)
          //           return Row(
          //             children: <Widget>[
          //               Expanded(
          //                 child: FlatButton(
          //                   onPressed: () {
          //                     ///ADD TO WISHLIST
          //                     BlocProvider.of<WishListBloc>(context).add(
          //                         AddToWishList(
          //                             wishListItem: new WishListItem(
          //                                 product: state.product)));
          //                   },
          //                   child: Text(
          //                     AppLocalizations.of(context)
          //                         .translate('wishlist')
          //                         .toUpperCase(),
          //                     style: TextStyle(color: Colors.black),
          //                   ),
          //                 ),
          //               ),
          //               Expanded(child: BlocBuilder<LoadingBloc, LoadingStates>(
          //                   builder: (context, loadingState) {
          //                 if (loadingState is AppLoading)
          //                   return RaisedButton(
          //                     onPressed: () {
          //                       //do nothing
          //                     },
          //                     child: Container(
          //                       height: 20,
          //                       width: 20,
          //                       child: CircularProgressIndicator(
          //                         backgroundColor: Colors.white,
          //                         strokeWidth: 2,
          //                       ),
          //                     ),
          //                   );
          //                 else
          //                   return RaisedButton(
          //                       onPressed: () {
          //                         BlocProvider.of<LoadingBloc>(context)
          //                           ..add(StartLoading());
          //
          //                         state.product.quantity = 1;
          //                         BlocProvider.of<CartBloc>(context).add(
          //                             AddCartItem(
          //                                 isFromLiveStream: false,
          //                                 cartItem: state.product,
          //                                 isLoggedIn:
          //                                     !(BlocProvider.of<LoginBloc>(
          //                                         context) is GuestUser)));
          //                       },
          //                       child: Text(AppLocalizations.of(context)
          //                           .translate('add-to-cart')
          //                           .toUpperCase()));
          //               })),
          //               SizedBox(
          //                 width: 8,
          //               )
          //             ],
          //           );
          //         else
          //           return Container(
          //             height: 0,
          //           );
          //       });
          //     } else
          //       return Container(
          //         height: 0,
          //       );
          //   }),
          // ),
          body: BlocBuilder<SingleProductBloc, ProductStates>(
              builder: (context, state) {
            if (state is FetchProductDetailsSuccess) {
              _controller =
                  VideoPlayerController.network(state.product.lastVideo);

              chewieController = ChewieController(
                videoPlayerController: _controller,
                aspectRatio: 3 / 2,
                autoInitialize: true,
                allowFullScreen: true,
                allowMuting: true,
                autoPlay: true,
                showControlsOnInitialize: false,
                showControls: true,
                looping: false,
              );
              return Consumer<OverlayHandlerProvider>(
                  builder: (context, overlayProvider, _) {
                return ListView(
                  padding: EdgeInsets.all(0),
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // if (!overlayProvider.inPipMode)
                    //   SizedBox(
                    //     height: 32.0,
                    //   ),
                    buildProductVideo(state.product),
                    if (!overlayProvider.inPipMode)
                      buildProductVideoReactions(state.product),
                    if (!overlayProvider.inPipMode)
                      buildProductDetails(state.product),
                  ],
                );
              });
            }
            return Container(
              child: Center(
                child: spinkit,
              ),
            );
          }),
        ),
      ),
    );
  }

  buildProductVideoReactions(Product product) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, top: 16.0, right: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.thumbsUp,
                    size: 16,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "1.2k",
                  ),
                ],
              ),
              SizedBox(
                width: 16,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.comment,
                    size: 16,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "20",
                  ),
                ],
              ),
            ],
          ),
          ProductVideoDownloader(product)
        ],
      ),
    );
  }

  buildProductVideo(Product product) {
    return Consumer<OverlayHandlerProvider>(
        builder: (context, overlayProvider, _) {
      if (overlayProvider.inPipMode) {
        chewieController = ChewieController(
          videoPlayerController: _controller,
          aspectRatio: 3 / 2,
          autoInitialize: true,
          allowFullScreen: true,
          allowMuting: true,
          autoPlay: true,
          showControls: false,
          looping: false,
        );
      } else {
        chewieController = ChewieController(
          videoPlayerController: _controller,
          aspectRatio: 3 / 2,
          autoInitialize: true,
          allowFullScreen: true,
          allowMuting: true,
          autoPlay: true,
          showControlsOnInitialize: false,
          showControls: true,
          looping: false,
        );
      }

      return Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  width: overlayProvider.inPipMode
                      ? (Constants.VIDEO_TITLE_HEIGHT_PIP * aspectRatio)
                      : MediaQuery.of(context).size.width,
                  color: Colors.black,
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: Chewie(
                        controller: chewieController,
                      )),
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
            Positioned(
              top: 8.0,
              left: 8.0,
              child: IconButton(
                  icon: Icon(Icons.keyboard_arrow_down),
                  color: Colors.white,
                  onPressed: () {
                    Provider.of<OverlayHandlerProvider>(context, listen: false)
                        .enablePip(aspectRatio);
                  }),
            ),
        ],
      );
    });
  }

  buildProductDetails(Product product) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
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
                      Expanded(
                        child: FlatButton(
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
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
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
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Icon(
                    Icons.loyalty,
                    size: 18,
                  ),
                  Text(
                    "You will earn 100 Tienda points on purchase of this product",
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ProductDescriptionContainer(product.specs),
          SizedBox(
            height: 10,
          ),
          CustomerOverallRatingBlock(product.id, product.overallRating,
              product.ratings, product.isPurchased),
          SizedBox(
            height: 10,
          ),
          (!product.isReviewed && product.isPurchased) ||
                  product.reviews.isNotEmpty
              ? Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        !(product.reviews.length == 1 &&
                                product.reviews[0].body == "")
                            ? Text(
                                AppLocalizations.of(context)
                                    .translate('reviews')
                                    .toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        !(product.reviews.length == 1 &&
                                product.reviews[0].body == "")
                            ? SizedBox(
                                height: 16,
                              )
                            : Container(),
                        !product.isReviewed && product.isPurchased
                            ? BlocProvider.value(
                                value: reviewBloc
                                  ..add(LoadReview(product.reviews)),
                                child: AddCustomerReviewContainer(product.id,
                                    (value) {
                                  print("CALL BACK RECEIVED");
                                  scrollController
                                      .animateTo(
                                          scrollController
                                                  .position.maxScrollExtent +
                                              500,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn)
                                      .then((value) => print("ANIMATE DONE"));
                                }),
                              )
                            : Container(),
                        BlocProvider.value(
                          value: reviewBloc..add(LoadReview(product.reviews)),
                          child: CustomerReviewContainer(product.reviews),
                        )
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
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
