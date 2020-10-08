import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/events/review-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/review-bloc.dart';
import 'package:tienda/bloc/single-product-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/product-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/wishlist.dart';
import 'package:tienda/view/checkout/checkout-orders-main-page.dart';
import 'package:tienda/view/products/add-customer-review-container.dart';
import 'package:tienda/view/products/customer-overall-rating-block.dart';
import 'package:tienda/view/products/customer-reviews-container.dart';
import 'package:tienda/view/products/product-description-container.dart';
import 'package:tienda/view/products/product-info-container.dart';
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
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    singleProductBloc.add(FetchProductDetails(productId: widget.productId));

    addToCartStream.listen((value) {
      if (value != null && value) {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
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
                                Navigator.of(context).pop();
                              },
                              child: Text('Continue Shopping')),
                          OutlineButton(
                            child: Text('CheckOut'),
                            color: Colors.black,
                            borderSide: BorderSide(color: Colors.black),
                            onPressed: () {
                              Navigator.of(context).pop();

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return BlocProvider(
                                    create: (context) => CheckOutBloc(),
                                    child: CheckoutOrdersMainPage(),
                                  );
                                }),
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                  actions: <Widget>[],
                ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return MultiBlocProvider(
        providers: [
          BlocProvider<ReviewBloc>(
            create: (BuildContext context) => ReviewBloc(),
          ),
          BlocProvider(
            create: (BuildContext context) => singleProductBloc,
          ),
        ],
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              automaticallyImplyLeading: true,
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
            body: BlocBuilder<SingleProductBloc, ProductStates>(
                builder: (context, state) {
              if (state is FetchProductDetailsSuccess) {
                return Container(
                  color: Colors.white,
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 100),
                    controller: scrollController,
                    children: [
                      CarouselSlider.builder(
                          itemCount: state.product.images.length,
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height / 2,
                            viewportFraction: 1.0,
                            disableCenter: true,
                            aspectRatio: 2.0,

                            enlargeCenterPage: false,
                            // autoPlay: false,
                          ),
                          carouselController: _controller,
                          itemBuilder: (BuildContext context, int itemIndex) =>
                              Container(
                                child: FadeInImage.memoryNetwork(
                                  image: state.product.images[itemIndex],
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  fit: BoxFit.cover,
                                  placeholder: kTransparentImage,
                                ),
                              )),
                      ProductInfoContainer(state.product),
                      SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<SingleProductBloc, ProductStates>(
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
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('wishlist')
                                            .toUpperCase(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: RaisedButton(
                                        onPressed: () {
                                          ///Log event to firebase
                                          FirebaseAnalytics().logAddToCart(
                                              itemId: state.product.id.toString(),
                                              itemName: state.product.nameEn,
                                              itemCategory:
                                              state.product.categoryId.toString(),
                                              quantity: 1);

                                          state.product.quantity = 1;
                                          BlocProvider.of<CartBloc>(context).add(
                                              AddCartItem(
                                                  cartItem: state.product,
                                                  isLoggedIn:
                                                  !(BlocProvider.of<LoginBloc>(context)
                                                  is GuestUser)));
                                          addToCartStream.sink.add(true);
                                        },
                                        child: Text(AppLocalizations.of(context)
                                            .translate('add-to-cart')
                                            .toUpperCase())),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  )
                                ],
                              );
                            } else
                              return Container();
                          }),
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
                      ProductDescriptionContainer(state.product.specs),
                      SizedBox(
                        height: 10,
                      ),
                      CustomerOverallRatingBlock(
                          state.product.id,
                          state.product.overallRating,
                          state.product.ratings,
                          state.product.isPurchased),
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
                                    !(state.product.reviews.length == 1 &&
                                            state.product.reviews[0].body == "")
                                        ? Text(
                                            AppLocalizations.of(context)
                                                .translate('reviews')
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Container(),
                                    !(state.product.reviews.length == 1 &&
                                            state.product.reviews[0].body == "")
                                        ? SizedBox(
                                            height: 16,
                                          )
                                        : Container(),
                                    !state.product.isReviewed &&
                                            state.product.isPurchased
                                        ? BlocProvider.value(
                                            value: BlocProvider.of<ReviewBloc>(
                                                context)
                                              ..add(LoadReview(
                                                  state.product.reviews)),
                                            child: AddCustomerReviewContainer(
                                                state.product.id, (value) {
                                              print("CALL BACK RECEIVED");
                                              scrollController
                                                  .animateTo(
                                                      scrollController.position
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
//                                      !state.product.isReviewed &&
//                                              state.product.isPurchased
//                                          ? SizedBox(
//                                              height: 10,
//                                            )
//                                          : Container(),
                                    BlocProvider.value(
                                      value: BlocProvider.of<ReviewBloc>(
                                          context)
                                        ..add(
                                            LoadReview(state.product.reviews)),
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
            })));
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
