import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/events/review-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/review-bloc.dart';
import 'package:tienda/bloc/single-product-bloc.dart';
import 'package:tienda/bloc/states/product-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/controller/video-controls.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/main.dart';
import 'package:tienda/model/wishlist.dart';
import 'package:tienda/view/products/add-customer-review-container.dart';
import 'package:tienda/view/products/customer-overall-rating-block.dart';
import 'package:tienda/view/products/customer-reviews-container.dart';
import 'package:tienda/view/products/presenter-info-container.dart';
import 'package:tienda/view/products/product-description-container.dart';
import 'package:tienda/view/products/product-info-container.dart';
import 'package:tienda/view/products/product-video-content.dart';
import 'package:transparent_image/transparent_image.dart';

class SingleProductPage extends StatefulWidget {
  final int productId;

  SingleProductPage(this.productId);

  @override
  _SingleProductPageState createState() => _SingleProductPageState();
}

class _SingleProductPageState extends State<SingleProductPage> {
  SingleProductBloc singleProductBloc = new SingleProductBloc();

  final addToCartStream = new BehaviorSubject<bool>();
  ScrollController scrollController = new ScrollController();
  int _current = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    singleProductBloc.add(FetchProductDetails(productId: widget.productId));

    addToCartStream.listen((value) {
      if(value != null && value){
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text("Material Dialog"),
              content: new Text("Product is added to cart"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close me!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ReviewBloc>(
            create: (BuildContext context) => ReviewBloc(),
          ),
          BlocProvider(
            create: (BuildContext context) => singleProductBloc,
          ),
        ],
        child: WillPopScope(
          onWillPop: () {
            VideoControls().controls.value.show = false;
            VideoControls().updateControls(VideoControls().controls.value);
            return Future.value(true);
          },
          child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                brightness: Brightness.light,
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.share,
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        shareProductDetails();
                      },
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: SafeArea(
                child: BlocBuilder<SingleProductBloc, ProductStates>(
                    builder: (context, state) {
                  if (state is FetchProductDetailsSuccess) {
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
                            child: Text(AppLocalizations.of(context)
                                .translate('wishlist')
                                .toUpperCase()),
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                              onPressed: () {
                                state.product.quantity = 1;
                                BlocProvider.of<CartBloc>(context)
                                    .add(AddCartItem(cartItem: state.product));
                                addToCartStream.sink.add(true);
                              },
                              child: Text(AppLocalizations.of(context)
                                  .translate('add-to-cart')
                                  .toUpperCase())),
                        ),
                      ],
                    );
                  } else
                    return Container();
                }),
              ),
              body: BlocBuilder<SingleProductBloc, ProductStates>(
                  builder: (context, state) {
                if (state is FetchProductDetailsSuccess) {
                  return Container(
                    color: Colors.grey[200],
                    child: ListView(
                      padding: EdgeInsets.all(0),
                      controller: scrollController,
                      children: <Widget>[
                        ProductVideoContent(state.product),
                        ProductInfoContainer(state.product),
                        state.product.images.isNotEmpty
                            ? Container(
                                color: Colors.white,
                                child: SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.product.images.length,
                                      itemBuilder: (BuildContext context,
                                              int index) =>
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              child: FadeInImage.memoryNetwork(
                                                image:
                                                    state.product.images[index],
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
                        state.product.presenter != null
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  PresenterInfoContainer(
                                      state.product.presenter),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        ProductDescriptionContainer(state.product.specs),
                        SizedBox(
                          height: 10,
                        ),
                        CustomerOverallRatingBlock(state.product.overallRating,
                            state.product.ratings, state.product.isPurchased),
                        SizedBox(
                          height: 10,
                        ),
                        (!state.product.isReviewed &&
                                    state.product.isPurchased) ||
                                state.product.reviews.isNotEmpty
                            ? Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ListView(
                                    padding: EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('reviews'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      !state.product.isReviewed &&
                                              state.product.isPurchased
                                          ? BlocProvider.value(
                                              value:
                                                  BlocProvider.of<ReviewBloc>(
                                                      context)
                                                    ..add(LoadReview(
                                                        state.product.reviews)),
                                              child: AddCustomerReviewContainer(
                                                  state.product.id, (value) {
                                                print("CALL BACK RECEIVED");
                                                scrollController
                                                    .animateTo(
                                                        scrollController
                                                                .position
                                                                .maxScrollExtent +
                                                            500,
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.easeIn)
                                                    .then((value) =>
                                                        print("ANIMATE DONE"));
                                              }),
                                            )
                                          : Container(),
                                      !state.product.isReviewed &&
                                              state.product.isPurchased
                                          ? SizedBox(
                                              height: 10,
                                            )
                                          : Container(),
                                      BlocProvider.value(
                                        value:
                                            BlocProvider.of<ReviewBloc>(context)
                                              ..add(LoadReview(
                                                  state.product.reviews)),
                                        child: CustomerReviewContainer(
                                            state.product.reviews),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
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
        ));
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
