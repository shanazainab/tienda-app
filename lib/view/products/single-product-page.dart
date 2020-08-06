import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_playout/player_state.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/events/review-events.dart';
import 'package:tienda/bloc/review-bloc.dart';
import 'package:tienda/bloc/single-product-bloc.dart';
import 'package:tienda/bloc/states/product-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/cart.dart';
import 'package:tienda/view/live-stream/video-playout.dart';
import 'package:tienda/view/products/add-customer-review-container.dart';
import 'package:tienda/view/products/customer-overall-rating-block.dart';
import 'package:tienda/view/products/customer-reviews-container.dart';
import 'package:tienda/view/products/product-description-container.dart';
import 'package:tienda/view/products/product-info-container.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';

class SingleProductPage extends StatefulWidget {
  final int productId;

  SingleProductPage(this.productId);

  @override
  _SingleProductPageState createState() => _SingleProductPageState();
}

class _SingleProductPageState extends State<SingleProductPage> {
  SingleProductBloc singleProductBloc = new SingleProductBloc();

  int _current = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    singleProductBloc.add(FetchProductDetails(productId: widget.productId));
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
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(44.0),
                // here the desired height
                child: CustomAppBar(
                  title: "",
                  showWishList: true,
                  showSearch: false,
                  showCart: true,
                  showNotification: false,
                  showLogo: false,
                )),
            bottomNavigationBar: BlocBuilder<SingleProductBloc, ProductStates>(
                builder: (context, state) {
              if (state is FetchProductDetailsSuccess) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        onPressed: () {},
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
                        },
                        child: Text(AppLocalizations.of(context)
                            .translate('add-to-cart')
                            .toUpperCase()),
                      ),
                    ),
                  ],
                );
              } else
                return Container();
            }),
            body: BlocBuilder<SingleProductBloc, ProductStates>(
                builder: (context, state) {
              if (state is FetchProductDetailsSuccess) {
                return Container(
                  color: Colors.grey[200],
                  child: ListView(
                    children: <Widget>[
//                      VideoPlayOut(
//                        url:
//                            'http://192.168.1.93:1935/test_presenter/myStream/playlist.m3u8',
//                        desiredState: PlayerState.PLAYING,
//                        showPlayerControls: true,
//                      ),

                      Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(Icons.play_circle_outline),
                        ),
                      ),
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
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  state.product.images[index],
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: Container(
                                                  height: 120,
                                                  width: 120,
                                                  color: Color(0xfff2f2e4),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                height: 120,
                                                color: Color(0xfff2f2e4),
                                              ),
                                            ),
                                          ),
                                        )),
                              ),
                            )
                          : Container(),
                      ProductInfoContainer(state.product),
                      SizedBox(
                        height: 10,
                      ),
                      ProductDescriptionContainer(state.product.specs),
                      SizedBox(
                        height: 10,
                      ),
                      CustomerOverallRatingBlock(
                          state.product.overallRating, state.product.ratings),
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
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    Text("Reviews"),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    !state.product.isReviewed &&
                                            state.product.isPurchased
                                        ? BlocProvider.value(
                                            value: BlocProvider.of<ReviewBloc>(
                                                context)
                                              ..add(LoadReview(
                                                  state.product.reviews)),
                                            child: AddCustomerReviewContainer(
                                                state.product.id),
                                          )
                                        : Container(),
                                    !state.product.isReviewed &&
                                            state.product.isPurchased
                                        ? SizedBox(
                                            height: 10,
                                          )
                                        : Container(),
                                     BlocProvider.value(
                                            value: BlocProvider.of<ReviewBloc>(
                                                context)
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
                return Container();
            })));
  }
}
