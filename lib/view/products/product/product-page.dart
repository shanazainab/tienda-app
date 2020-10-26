import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/cart-bloc.dart';
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
import 'package:tienda/view/cart/page/cart-page.dart';
import 'package:tienda/view/live-stream/widget/products/product-description-tab.dart';
import 'package:tienda/view/products/customer-reviews.dart';
import 'package:tienda/view/products/product-info-container.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductPage extends StatefulWidget {
  final int productId;

  ProductPage(this.productId);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
                                  return CartPage();
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
                      SizedBox(
                        height: 10,
                      ),
                      ProductInfoContainer(state.product),
                      Row(
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
                      BlocBuilder<SingleProductBloc, ProductStates>(
                          builder: (context, state) {
                        if (state is FetchProductDetailsSuccess) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: <Widget>[
                                OutlineButton(
                                  borderSide: BorderSide(
                                    color: Color(0xff50C0A8),
                                  ),
                                  onPressed: () {
                                    ///ADD TO WISHLIST
                                    BlocProvider.of<WishListBloc>(context).add(
                                        AddToWishList(
                                            wishListItem: new WishListItem(
                                                product: state.product)));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/heart.svg",
                                        color: Colors.black,
                                        height: 16,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('wishlist')
                                            .toUpperCase(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: RaisedButton(
                                      onPressed: () {
                                        ///Log event to firebase
                                        FirebaseAnalytics().logAddToCart(
                                            itemId: state.product.id.toString(),
                                            itemName: state.product.nameEn,
                                            itemCategory: state
                                                .product.categoryId
                                                .toString(),
                                            quantity: 1);

                                        state.product.quantity = 1;
                                        BlocProvider.of<CartBloc>(context).add(
                                            AddCartItem(
                                                cartItem: state.product,
                                                isLoggedIn: !(BlocProvider.of<
                                                        LoginBloc>(context)
                                                    is GuestUser)));
                                        addToCartStream.sink.add(true);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/svg/cart.svg",
                                            color: Colors.white,
                                            height: 17,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text("ADD TO CART"),
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  width: 8,
                                )
                              ],
                            ),
                          );
                        } else
                          return Container();
                      }),
                      SizedBox(
                        height: 10,
                      ),
                      ProductDescriptionTab(state.product, (pageOffset) {
                        scrollController.animateTo(pageOffset,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                      }),
                      SizedBox(
                        height: 10,
                      ),
                      BlocProvider(
                        create: (BuildContext context) => ReviewBloc()
                          ..add(LoadReview(state.product.reviews)),
                        child: CustomerReviews(product: state.product),
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
      uriPrefix: 'https://l.tienda.ae/l',
      link: Uri.parse('https://tienda.ae/product/${widget.productId}'),
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
        subject: "Check out this cool product in Tienda !!",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
