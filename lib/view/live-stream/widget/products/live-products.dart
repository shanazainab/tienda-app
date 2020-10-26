import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tienda/bloc/bottom-nav-bar-bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/bottom-nav-bar-events.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/events/loading-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/live-stream-product-bloc.dart';
import 'package:tienda/bloc/live-stream-product-details-bloc.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/live-stream-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/model/live-response.dart';
import 'package:tienda/model/wishlist.dart';

class LiveProducts extends StatelessWidget {
  const LiveProducts(
      {Key key, this.liveResponse, this.liveProductsPanelController})
      : super(key: key);
  final LiveResponse liveResponse;
  final PanelController liveProductsPanelController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "LIVE PRODUCTS",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Text(
                "${liveResponse.products.length} ITEMS",
                style: TextStyle(fontSize: 13, color: Color(0xFF555555)),
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
            itemBuilder: (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<LiveStreamProductDetailsBloc>(context)
                          .add(ShowProduct(liveResponse.products[index]));
                      BlocProvider.of<BottomNavBarBloc>(context)
                          .add(ChangeBottomNavBarState(-1, true));
                      liveProductsPanelController.open();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          border: Border.all(
                              color: Color.fromRGBO(96, 97, 112, 0.08))),
                      width: MediaQuery.of(context).size.width - 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: 96,
                            child: CachedNetworkImage(
                              imageUrl: liveResponse.products[index].thumbnail,
                              height: 100,
                              width: 96,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    liveResponse.products[index].nameEn,
                                    softWrap: true,
                                    style: TextStyle(),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          RatingBar(
                                            initialRating: liveResponse
                                                .products[index].overallRating,
                                            minRating: 1,
                                            itemSize: 20,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 0.5),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Color(0xFFf9d572),
                                              size: 14,
                                            ),
                                            // onRatingUpdate:
                                            //     (rating) {
                                            //   print(rating);
                                            // },
                                          ),
                                          Text(liveResponse
                                              .products[index].totalReviews
                                              .toString())
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: BlocBuilder<
                                                LiveStreamProductBloc,
                                                LiveStreamStates>(
                                            builder: (context, state) {
                                          if (state
                                                  is UpdateWishListProductsSuccess &&
                                              state.products[index]
                                                      .isWishListed !=
                                                  null &&
                                              state
                                                  .products[index].isWishListed)
                                            return GestureDetector(
                                              onTap: () {
                                                state.products[index]
                                                    .isWishListed = false;
                                                BlocProvider.of<
                                                            LiveStreamProductBloc>(
                                                        context)
                                                    .add(UpdateWishListProducts(
                                                        state.products));
                                              },
                                              child: SvgPicture.asset(
                                                  "assets/svg/heart.svg",
                                                  color: Color(0xFFff2e63)),
                                            );
                                          else if (state
                                                  is UpdateWishListProductsSuccess &&
                                              (state.products[index]
                                                          .isWishListed ==
                                                      null ||
                                                  state.products[index]
                                                              .isWishListed !=
                                                          null &&
                                                      !state.products[index]
                                                          .isWishListed))
                                            return GestureDetector(
                                              onTap: () {
                                                BlocProvider.of<WishListBloc>(
                                                        context)
                                                    .add(AddToWishList(
                                                        wishListItem:
                                                            new WishListItem(
                                                                product: liveResponse
                                                                        .products[
                                                                    index])));

                                                state.products[index]
                                                    .isWishListed = true;
                                                BlocProvider.of<
                                                            LiveStreamProductBloc>(
                                                        context)
                                                    .add(UpdateWishListProducts(
                                                        state.products));
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
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFc30045)),
                                          )
                                        ],
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: SizedBox(
                                            width: 94,
                                            height: 32,
                                            child: RaisedButton(

                                              padding: EdgeInsets.only(top:8),

                                              onPressed: () {
                                                BlocProvider.of<LoadingBloc>(
                                                    context)
                                                  ..add(StartLoading());

                                                liveResponse.products[index]
                                                    .quantity = 1;
                                                BlocProvider.of<CartBloc>(
                                                        context)
                                                    .add(AddCartItem(
                                                        isFromLiveStream: false,
                                                        cartItem: liveResponse
                                                            .products[index],
                                                        isLoggedIn:
                                                            !(BlocProvider.of<
                                                                        LoginBloc>(
                                                                    context)
                                                                is GuestUser)));
                                              },
                                              color: Color(0xFF50c0a8),
                                              child: Text(
                                                "Add to Cart",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Gotham',
                                                    color: Color(0xFFf6f6f6),
                                                    fontWeight:
                                                        FontWeight.bold),
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
                  ),
                )),
      ],
    );
  }
}
