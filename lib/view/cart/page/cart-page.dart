import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/bottom-nav-bar-bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/connectivity-bloc.dart';
import 'package:tienda/bloc/events/bottom-nav-bar-events.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/loading-events.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/view/cart/page/empty-cart-page.dart';
import 'package:tienda/view/cart/widget/cart-checkout-panel.dart';
import 'package:tienda/view/cart/widget/cart-items-container.dart';
import 'package:tienda/view/cart/widget/tienda-points-redeem-container.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return BlocBuilder<CartBloc, CartStates>(
      builder: (context, state) {
        if (state is LoadCartSuccess && state.cart != null) {
          BlocProvider.of<LoadingBloc>(context)..add(StopLoading());

          return WillPopScope(
            onWillPop: () {
              BlocProvider.of<BottomNavBarBloc>(context)
                  .add(ChangeBottomNavBarState(0, false));
              return Future.value(true);
            },
            child: Scaffold(
              bottomNavigationBar:
                  (state is LoadCartSuccess && state.cart != null)
                      ? CartCheckoutPanel(state.cart)
                      : Container(
                          height: 0,
                        ),
              appBar: AppBar(
                  elevation: 0,
                  automaticallyImplyLeading: true,
                  centerTitle: true,
                  brightness: Brightness.light,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      BlocProvider.of<BottomNavBarBloc>(context)
                          .add(ChangeBottomNavBarState(0, false));
                    },
                  ),
                  title: state is LoadCartSuccess && state.cart != null
                      ? Text('Shopping Bag (${state.cart.products.length})',
                          style: const TextStyle(
                              color: const Color(0xff282828),
                              fontWeight: FontWeight.w700,
                              fontFamily: "SFProText",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.center)
                      : Text('Shopping Bag',
                          style: const TextStyle(
                              color: const Color(0xff282828),
                              fontWeight: FontWeight.w700,
                              fontFamily: "SFProText",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.center)),
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 100, top: 20),
                  physics: ScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: TiendaPointsRedeemContainer(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CartItemsContainer(state.cart),
                    SizedBox(
                      height: 20,
                    ),
                    ExpansionTile(
                      initiallyExpanded: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/coupon 1.png",
                                height: 24,
                                width: 24,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Apply Coupon',
                                style: TextStyle(
                                  color: Color(0xff282828),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          state.cart.summary.isCoupon
                              ? Text(
                                  '- AED ${state.cart.summary.couponDiscount}',
                                  style: TextStyle(
                                    color: Color(0xff282828),
                                    fontSize: 13,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      children: [
                        !state.cart.summary.isCoupon
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 38,
                                        child: TextFormField(
                                          controller: textEditingController,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left: 8, right: 8),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        BlocProvider.of<CartBloc>(context).add(
                                            ApplyCoupon(
                                                textEditingController.text));
                                      },
                                      child: Text("APPLY"),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        state.cart.summary.isCoupon
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                state.cart.summary.appliedCoupon
                                                            .code !=
                                                        null
                                                    ? state.cart.summary
                                                        .appliedCoupon.code
                                                    : '',
                                                style: TextStyle(
                                                    color: Color(0xffAF0044)),
                                              ),
                                            )),
                                        RaisedButton(
                                          onPressed: () {
                                            removeCoupon(state.cart.summary
                                                .appliedCoupon.code);
                                          },
                                          child: Text("REMOVE"),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(state.cart.summary.appliedCoupon
                                                .name !=
                                            null
                                        ? state.cart.summary.appliedCoupon.name
                                        : '')
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          BlocProvider.of<LoadingBloc>(context)..add(StopLoading());
          return EmptyCartPage();
        }
      },
    );
  }

  void checkConnectivity() {
    ConnectivityBloc().connectivityStream.listen((value) {
      if (value == ConnectivityResult.none) {
        BlocProvider.of<CartBloc>(context).add(OfflineLoadCart());
      }
    });
  }

  void removeCoupon(String couponCode) {
    BlocProvider.of<CartBloc>(context).add(RemoveCoupon(couponCode));
  }
}
