import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/loading-events.dart';
import 'package:tienda/bloc/events/wishlist-events.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/cart.dart';
import 'package:tienda/model/wishlist.dart';
import 'package:tienda/video-overlays/overlay_service.dart';
import 'package:tienda/view/products/product-review-page.dart';
import 'package:transparent_image/transparent_image.dart';

class CartItemsContainer extends StatefulWidget {
  final Cart cart;

  CartItemsContainer(this.cart);

  @override
  _CartItemsContainerState createState() => _CartItemsContainerState();
}

class _CartItemsContainerState extends State<CartItemsContainer> {
  final RealTimeController realTimeController = new RealTimeController();

  final SlidableController slidableController = SlidableController();

  final List<GlobalKey<SlidableState>> slidableKeys = new List();

  final List<bool> showCoupon = new List();

  @override
  void initState() {
    // TODO: implement initState

    for (final product in widget.cart.products) {
      slidableKeys.add(new GlobalKey<SlidableState>());
      showCoupon.add(false);
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 5));
      if (slidableKeys.isNotEmpty) {
        slidableKeys[0]
            .currentState
            .open(actionType: SlideActionType.secondary);
        await Future.delayed(Duration(seconds: 3));
        slidableKeys[0].currentState.close();
      }
    });
  }

  @override
  Widget build(BuildContext contextA) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      physics: ScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      itemCount: widget.cart.products.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {
              OverlayService().addVideoTitleOverlay(
                  context,
                  ProductReviewPage(widget.cart.products[index].id),
                  false,
                  false);
            },
            child: Slidable(
              key: slidableKeys[index],
              controller: slidableController,
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: new Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 4,
                      ),
                      FadeInImage.memoryNetwork(
                        image: widget.cart.products[index].thumbnail,
                        width: 100,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: kTransparentImage,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              widget.cart.products[index].brand != null
                                  ? Text(
                                      widget.cart.products[index].brand,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Container(),
                              Text(
                                appLanguage.appLocal == Locale('en')
                                    ? widget.cart.products[index].nameEn
                                    : widget.cart.products[index].nameAr,
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.all(Radius.zero)),
                                        child: Container(
                                          height: 32,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {


                                                    if (widget
                                                            .cart
                                                            .products[index]
                                                            .quantity ==
                                                        1) {
                                                      ///delete the item
                                                      ///or don do anything
                                                    } else {
                                                      BlocProvider.of<
                                                          LoadingBloc>(context)
                                                        ..add(StartLoading());
                                                      widget
                                                          .cart
                                                          .products[index]
                                                          .quantity = widget
                                                              .cart
                                                              .products[index]
                                                              .quantity -
                                                          1;
                                                      BlocProvider.of<CartBloc>(
                                                          context)
                                                        ..add(EditCartItem(
                                                            cart: widget.cart,
                                                            isLoggedIn: !(BlocProvider.of<
                                                                            LoginBloc>(
                                                                        context)
                                                                    .state
                                                                is GuestUser),
                                                            editType:
                                                                "QUANTITY EDIT",
                                                            cartItem: widget
                                                                    .cart
                                                                    .products[
                                                                index]));
                                                    }
                                                  },
                                                  child: Text(
                                                    "-",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0,
                                                          right: 12),
                                                  child: Text(
                                                    widget.cart.products[index]
                                                        .quantity
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    BlocProvider.of<
                                                        LoadingBloc>(context)
                                                      ..add(StartLoading());

                                                    widget.cart.products[index]
                                                        .quantity = widget
                                                            .cart
                                                            .products[index]
                                                            .quantity +
                                                        1;

                                                    BlocProvider.of<CartBloc>(
                                                        context)
                                                      ..add(EditCartItem(
                                                          cart: widget.cart,
                                                          isLoggedIn: !(BlocProvider
                                                                      .of<LoginBloc>(
                                                                          context)
                                                                  .state
                                                              is GuestUser),
                                                          editType:
                                                              "QUANTITY EDIT",
                                                          cartItem: widget.cart
                                                                  .products[
                                                              index]));
                                                  },
                                                  child: Text(
                                                    "+",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (widget.cart.products[index].coupon !=
                                              null &&
                                          widget.cart.products[index].coupon
                                                  .id !=
                                              null)
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showCoupon[index] =
                                                  !showCoupon[index];
                                            });
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.zero)),
                                            child: Container(
                                              height: 32,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SvgPicture.asset(
                                                  "assets/svg/gift.svg",
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                  Text(
                                    '${AppLocalizations.of(context).translate('aed')} ${widget.cart.products[index].price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xffAF0044)),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: showCoupon[index],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          color: Colors.pink.withOpacity(0.1),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4,
                                                bottom: 4,
                                                left: 8.0,
                                                right: 8.0),
                                            child: Text(
                                              widget.cart.products[index].coupon
                                                          .code !=
                                                      null
                                                  ? widget.cart.products[index]
                                                      .coupon.code
                                                  : '',
                                              style: TextStyle(
                                                  color: Color(0xffAF0044)),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(widget.cart.products[index].coupon
                                                  .name !=
                                              null
                                          ? widget
                                              .cart.products[index].coupon.name
                                          : '')
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  StreamBuilder<Map<String, dynamic>>(
                      stream: realTimeController.liveCheckOutStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        var count;

                        print(
                            "PRODUCT ID IN :${widget.cart.products[index].id}");
                        if (snapshot.data != null) {
                          for (final productId in snapshot.data.keys.toList()) {
                            print("PRODUCT KEY : $productId");
                            if (productId ==
                                widget.cart.products[index].id.toString()) {
                              count = snapshot.data[productId];
                            }
                          }
                          return count == null
                              ? Container()
                              : Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "$count added this product to cart",
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                        } else
                          return Container();
                      }),
                ],
              )),
              secondaryActions: <Widget>[
                IconSlideAction(
                  foregroundColor: Colors.white,
                  caption: 'Wishlist',
                  color: Color(0xff50c0a8),
                  icon: FontAwesomeIcons.heart,
                  onTap: () {
                    BlocProvider.of<LoadingBloc>(context)..add(StartLoading());

                    BlocProvider.of<WishListBloc>(context).add(AddToWishList(
                        wishListItem: new WishListItem(
                      product: widget.cart.products[index],
                    )));

                    BlocProvider.of<CartBloc>(context).add(DeleteCartItem(
                        isLoggedIn: !(BlocProvider.of<LoginBloc>(context).state
                            is GuestUser),
                        cart: widget.cart,
                        cartItem: widget.cart.products[index]));
                  },
                ),
                IconSlideAction(
                  caption: 'Remove',
                  foregroundColor: Colors.white,
                  color: Color(0xfff15223),
                  icon: Icons.delete,
                  onTap: () {
                    BlocProvider.of<LoadingBloc>(context)..add(StartLoading());

                    BlocProvider.of<CartBloc>(context).add(DeleteCartItem(
                        isLoggedIn: !(BlocProvider.of<LoginBloc>(context).state
                            is GuestUser),
                        cart: widget.cart,
                        cartItem: widget.cart.products[index]));
                  },
                ),
              ],
            ));
      },
    );
  }
}
