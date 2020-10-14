import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/bottom-nav-bar-bloc.dart';
import 'package:tienda/bloc/checkout-bloc.dart';
import 'package:tienda/bloc/events/bottom-nav-bar-events.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/loading-states.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/cart.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/view/cart/cart-items-container.dart';
import 'package:tienda/view/checkout/cart-bottom-bar.dart';
import 'package:tienda/view/live-stream/cart-checkout-pop-up.dart';
import 'package:tienda/view/login/login-main-page.dart';

class LiveStreamCartContainer extends StatelessWidget {
  final Cart cart;
  final CartCheckOutPopVisibility cartCheckOutPopVisibility;

  final RealTimeController realTimeController = new RealTimeController();

  final Order order;

  LiveStreamCartContainer(
      this.cart, this.cartCheckOutPopVisibility, this.order);

  @override
  Widget build(BuildContext context) {
    return cart != null
        ? Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${AppLocalizations.of(context).translate("shopping-bag")} (${cart.products.length})",
                          style: TextStyle(
                            color: Color(0xff282828),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            cartCheckOutPopVisibility(true);
                            BlocProvider.of<BottomNavBarBloc>(context)
                                .add(ChangeBottomNavBarState(-1, false));
                          },
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  Expanded(child: CartItemsContainer(cart)),
                  // if (state.cart != null) priceContainer(state.cart.cartPrice)
                ],
              ),
              if (cart != null)
                Align(
                    alignment: Alignment.bottomCenter,
                    child: CartBottomBar(cart)),
            ],
          )
        : Container(
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
}
