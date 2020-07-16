import 'package:flutter/material.dart';
import 'package:tienda/view/checkout/order-summary-container.dart';
import 'package:tienda/view/checkout/payment-container.dart';

class CheckoutOrdersMainPage extends StatefulWidget {
  @override
  _CheckoutOrdersMainPageState createState() => _CheckoutOrdersMainPageState();
}

class _CheckoutOrdersMainPageState extends State<CheckoutOrdersMainPage> {
  PageController pageController = new PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("block"),
            Expanded(
              child: Container(
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  controller: pageController,
                  children: <Widget>[
                    OrderSummaryContainer(),
                    PaymentContainer(),
                    Container(
                      color: Colors.deepPurple,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
