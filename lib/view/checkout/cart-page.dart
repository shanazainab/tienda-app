import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/connectivity-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/loading-events.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/states/cart-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/cart/cart-items-container.dart';
import 'package:tienda/view/checkout/price-details-container.dart';
import 'package:tienda/view/checkout/tienda-points-redeem-container.dart';

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

          return ListView(
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
              Expanded(
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    CartItemsContainer(state.cart),

                    // if (state.cart != null) priceContainer(state.cart.cartPrice)
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ExpansionTile(
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
                            '- AED 120.00',
                            style: TextStyle(
                              color: Color(0xff282828),
                              fontSize: 13,
                            ),
                          )
                        : Container(),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 38,
                            child: TextFormField(
                              controller: textEditingController,
                              decoration:
                                  InputDecoration(border: OutlineInputBorder()),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        RaisedButton(
                          onPressed: () {
                            BlocProvider.of<CartBloc>(context)
                                .add(ApplyCoupon(textEditingController.text));
                          },
                          child: Text("APPLY"),
                        )
                      ],
                    ),
                  ),
                  state.cart.summary.isCoupon
                      ? Text("Coupon Applied!")
                      : Text("No Coupon Applied")
                ],
              )
            ],
          );
        } else {
          BlocProvider.of<LoadingBloc>(context)..add(StopLoading());
          return Container(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_basket,
                    size: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Your Cart is Empty",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
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
}
