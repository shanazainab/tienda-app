import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/events/checkout-events.dart';
import 'package:tienda/bloc/events/saved-card-events.dart';
import 'package:tienda/bloc/live-stream-checkout-bloc.dart';
import 'package:tienda/bloc/saved-card-bloc.dart';
import 'package:tienda/bloc/states/checkout-states.dart';
import 'package:tienda/model/delivery-address.dart';
import 'package:tienda/model/payment-card.dart';
import 'package:tienda/view/live-stream/widget/checkout/main-screen.dart';
import 'package:tienda/view/live-stream/widget/checkout/payment-method-container.dart';

import 'choose-delivery-address.dart';

class CheckoutPanel extends StatelessWidget {
  final PageController pageController = new PageController(
    initialPage: 0,
  );

  final int presenterId;

  CheckoutPanel({this.presenterId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveStreamCheckOutBloc, CheckoutStates>(
        builder: (context, checkoutState) {
      if (checkoutState is LiveCheckoutInitializationComplete)
        return buildContents(
            context, checkoutState.deliveryAddress, checkoutState.card);
      if (checkoutState is UpdateLiveCheckoutComplete)
        return buildContents(
            context, checkoutState.deliveryAddress, checkoutState.card);
      else
        return Container();
    });
  }

  buildContents(BuildContext context, DeliveryAddress deliveryAddress,
      PaymentCard paymentCard) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)),
        color: Colors.white,
      ),
      child: PageView(
        physics: new NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: pageController,
        children: <Widget>[
          ///Checkout main page view

          CheckOutMainScreen(onRedirection: (index) {
            pageController.jumpToPage(index);
          }),

          ///Saved delivery address page view
          BlocProvider(
            create: (context) => AddressBloc()..add(LoadSavedAddress()),
            child: ChooseDeliveryAddress(
              onRedirection: (index) {
                pageController.jumpToPage(index);

              },
              onSelectedAddress: (address) {
                BlocProvider.of<LiveStreamCheckOutBloc>(context).add(
                    UpdateLiveCheckout(
                        deliveryAddress: address, card: paymentCard));
                pageController.jumpToPage(0);

              },
            ),
          ),

          ///Saved payment page view
          BlocProvider(
            create: (context) => SavedCardBloc()..add(LoadSavedCards()),
            child: PaymentMethodContainer(
              onRedirection: (index) {
                pageController.jumpToPage(index);

              },
              onChosenPayment: (card) {
                BlocProvider.of<LiveStreamCheckOutBloc>(context).add(
                    UpdateLiveCheckout(
                        deliveryAddress: deliveryAddress, card: card));
                pageController.jumpToPage(0);

              },
            ),
          ),

          ///Check completion status page view
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('ORDER SUCCESS'),
                RaisedButton(
                  onPressed: () {},
                  child: Text("Continue Watching"),
                )
              ],
            )),
          ),
        ],
      ),
    );
  }
}
