import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/events/loading-events.dart';
import 'package:tienda/bloc/live-stream-product-details-bloc.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/bloc/states/live-stream-states.dart';
import 'package:tienda/bloc/states/loading-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/view/live-stream/widget/products/product-description-tab.dart';
import 'package:tienda/view/products/product-info-container.dart';

import '../../../../localization.dart';

typedef ClosePanel = Function(bool shouldClose);

class LiveProductDetails extends StatefulWidget {
  final Presenter presenter;
  final ClosePanel closePanel;

  LiveProductDetails(this.presenter, this.closePanel);

  @override
  _LiveProductDetailsState createState() => _LiveProductDetailsState();
}

class _LiveProductDetailsState extends State<LiveProductDetails> {
  final RealTimeController realTimeController = new RealTimeController();

  bool showDropDown = false;

  ScrollController scrollController =  new ScrollController();

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return BlocListener<CartBloc, CartStates>(
      listener: (context, state) {
        if (state is LoadCartSuccess) {
          BlocProvider.of<LoadingBloc>(context)..add(StopLoading());
        }
      },
      child: BlocBuilder<LiveStreamProductDetailsBloc, LiveStreamStates>(
          builder: (context, state) {
        if (state is ShowProductSuccess) {
          return Stack(
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Product details',
                            style: TextStyle(
                              color: Color(0xff282828),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                widget.closePanel(true);
                              })
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        physics: ScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 100),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: state.product.thumbnail,
                                    width: MediaQuery.of(context).size.width,
                                    height: 326,
                                    fit: BoxFit.contain,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 16,
                                        ),
                                        state.product.brand != null
                                            ? Text(
                                                state.product.brand,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : Container(),

                                        Text(
                                            appLanguage.appLocal == Locale('en')
                                                ? state.product.nameEn
                                                : state.product.nameAr,
                                            style: TextStyle(
                                              color: Color(0xff3f3b3b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: 0,
                                            )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                              '${AppLocalizations.of(context).translate('aed')} ${state.product.price.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Color(0xff008c84),
                                                fontSize: 21,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                                letterSpacing: 0,
                                              )),
                                        ),
                                        new Text("Inclusive of VAT",
                                            style: TextStyle(
                                              fontFamily: 'SFProDisplay',
                                              color: Color(0xff3f3b3b),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: 0,
                                            )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12.0),
                                          child: RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff135c39),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Gotham",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                                text: "12 "),
                                            TextSpan(
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff135c39),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Gotham",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                                text: "left in stock")
                                          ])),
                                        ),
                                        state.product.sizes != null &&
                                                state.product.sizes.isNotEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text("Choose Size",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'GothamMedium',
                                                          color:
                                                              Color(0xff555555),
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          letterSpacing: 0,
                                                        )),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: state
                                                              .product
                                                              .sizes
                                                              .length,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemBuilder: (BuildContext
                                                                      context,
                                                                  int index) =>
                                                              CircleAvatar(
                                                                radius: 20,
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        200],
                                                                child: Text(state
                                                                    .product
                                                                    .sizes[
                                                                        index]
                                                                    .size),
                                                              )),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(),

                                        state.product.colors != null &&
                                                state.product.colors.isNotEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text("Choose Color",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'GothamMedium',
                                                          color:
                                                              Color(0xff555555),
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          letterSpacing: 0,
                                                        )),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: state
                                                              .product
                                                              .colors
                                                              .length,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemBuilder: (BuildContext
                                                                      context,
                                                                  int index) =>
                                                              CircleAvatar(
                                                                  radius: 20,
                                                                  backgroundColor: hexToColor(state
                                                                      .product
                                                                      .colors[
                                                                          index]
                                                                      .colorHex))),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(),

                                        ///testing
                                        ///Remove for production
                                        ///Actual implementation done below with stream
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12.0),
                                          child: Container(
                                              width: 270,
                                              height: 42,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 24,
                                                      width: 24,
                                                      color: Colors.white,
                                                      child: SvgPicture.asset(
                                                        "assets/svg/realtime-cart.svg",
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "12 viewers in the last few hours just",
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff282828),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontFamily:
                                                                  "Gotham",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 12.0),
                                                        ),
                                                        Text(
                                                          "bought this item",
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff282828),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  "Gotham",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 12.0),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              decoration: new BoxDecoration(
                                                  color: Color(0xffffdc98),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3))),
                                        ),

                                        ///ADD TO CART LIVE UPDATE
                                        StreamBuilder<Map<String, dynamic>>(
                                            stream: realTimeController
                                                .liveAddCartStream,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<
                                                        Map<String, dynamic>>
                                                    snapshot) {
                                              var count;

                                              print(
                                                  "PRODUCT ID IN :${state.product.id}");
                                              if (snapshot.data != null) {
                                                for (final productId in snapshot
                                                    .data.keys
                                                    .toList()) {
                                                  print(
                                                      "PRODUCT KEY : $productId");
                                                  if (productId ==
                                                      state.product.id
                                                          .toString()) {
                                                    count = snapshot
                                                        .data[productId];
                                                  }
                                                }
                                                return count == null
                                                    ? Container()
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 12.0),
                                                        child: Container(
                                                            width: 270,
                                                            height: 42,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      right: 8),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    height: 24,
                                                                    width: 24,
                                                                    color: Colors
                                                                        .white,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      "assets/svg/realtime-cart.svg",
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "$count viewers in the last few hours just",
                                                                        style: const TextStyle(
                                                                            color: const Color(
                                                                                0xff282828),
                                                                            fontWeight: FontWeight
                                                                                .w700,
                                                                            fontFamily:
                                                                                "Gotham",
                                                                            fontStyle:
                                                                                FontStyle.normal,
                                                                            fontSize: 12.0),
                                                                      ),
                                                                      Text(
                                                                        "bought this item",
                                                                        style: const TextStyle(
                                                                            color: const Color(
                                                                                0xff282828),
                                                                            fontWeight: FontWeight
                                                                                .w400,
                                                                            fontFamily:
                                                                                "Gotham",
                                                                            fontStyle:
                                                                                FontStyle.normal,
                                                                            fontSize: 12.0),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            decoration: new BoxDecoration(
                                                                color: Color(
                                                                    0xffffdc98),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3))),
                                                      );
                                              } else
                                                return Container();
                                            }),

                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  side: BorderSide(
                                                      color: Colors.grey[200],
                                                      width: 0.5)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        print("TAPPED");

                                                        if (state.product
                                                                .quantity ==
                                                            1) {
                                                          ///delete the item
                                                          ///or don do anything
                                                        } else {
                                                          if (state.product
                                                                  .quantity ==
                                                              null) {
                                                            state.product
                                                                .quantity = 1;
                                                          } else
                                                            state.product
                                                                .quantity = state
                                                                    .product
                                                                    .quantity -
                                                                1;
                                                          BlocProvider.of<
                                                              CartBloc>(context)
                                                            ..add(EditCartItem(
                                                                isLoggedIn: !(BlocProvider.of<LoginBloc>(
                                                                            context)
                                                                        .state
                                                                    is GuestUser),
                                                                editType:
                                                                    "QUANTITY EDIT",
                                                                cartItem: state
                                                                    .product));
                                                          BlocProvider.of<
                                                                  LiveStreamProductDetailsBloc>(
                                                              context)
                                                            ..add(ShowProduct(
                                                                state.product));
                                                        }
                                                      },
                                                      child: Text('-'),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8),
                                                      child: Text(
                                                        state.product
                                                                    .quantity ==
                                                                null
                                                            ? "1"
                                                            : state.product
                                                                .quantity
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        print("TAPPED");

                                                        if (state.product
                                                                .quantity ==
                                                            null) {
                                                          state.product
                                                              .quantity = 2;
                                                        } else
                                                          state.product
                                                              .quantity = state
                                                                  .product
                                                                  .quantity +
                                                              1;

                                                        BlocProvider.of<
                                                            CartBloc>(context)
                                                          ..add(EditCartItem(
                                                              isLoggedIn: !(BlocProvider.of<
                                                                              LoginBloc>(
                                                                          context)
                                                                      .state
                                                                  is GuestUser),
                                                              editType:
                                                                  "QUANTITY EDIT",
                                                              cartItem: state
                                                                  .product));

                                                        BlocProvider.of<
                                                                LiveStreamProductDetailsBloc>(
                                                            context)
                                                          ..add(ShowProduct(
                                                              state.product));
                                                      },
                                                      child: Text('+'),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            BlocBuilder<LoadingBloc,
                                                    LoadingStates>(
                                                builder:
                                                    (context, loadingState) {
                                              if (loadingState is NotLoading) {
                                                return Expanded(
                                                  child: RaisedButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                          LoadingBloc>(context)
                                                        ..add(StartLoading());

                                                      BlocProvider.of<CartBloc>(
                                                              context)
                                                          .add(AddCartItem(
                                                        presenterId:
                                                            widget.presenter.id,
                                                        isFromLiveStream: true,
                                                        isLoggedIn: !(BlocProvider
                                                                .of<LoginBloc>(
                                                                    context)
                                                            .state is GuestUser),
                                                        cartItem: state.product,
                                                      ));
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
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
                                                    ),
                                                  ),
                                                );
                                              } else
                                                return Expanded(
                                                  child: RaisedButton(
                                                    onPressed: () {},
                                                    child: Container(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor:
                                                            Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                            })
                                          ],
                                        ),

                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          state.product.specs != null
                              ? ProductDescriptionTab(state.product,
                                  (position) {
                                  scrollController.animateTo(position,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeIn);
                                })
                              : Container(),
                        ],
                      ),
                    ),
                  ]),
            ],
          );
        } else
          return Container();
      }),
    );
  }
}
