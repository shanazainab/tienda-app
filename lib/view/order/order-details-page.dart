import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/view/order/order-tracking-page.dart';
import 'package:tienda/view/order/order-tracking-time-line.dart';
import 'dart:math' as math;

import 'package:tienda/view/widgets/custom-app-bar.dart';

class OrdersDetailsPage extends StatefulWidget {
  @override
  _OrdersDetailsPageState createState() => _OrdersDetailsPageState();
}

class _OrdersDetailsPageState extends State<OrdersDetailsPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  final _trackNowStream = BehaviorSubject<bool>();

  double height = 150;

  @override
  void initState() {
    // TODO: implement initState
    _trackNowStream.add(false);

    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(44.0), // here the desired height

          child: CustomAppBar(
            title: "Order Details",
            showWishList: false,
            showSearch: false,
            showCart: false,
            showLogo: false,
          )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Order No 12123232"),
                        Text("Expected Delivery 10 Jun")
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: 160,
                      alignment: Alignment.bottomLeft,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Stack(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      height: 160,
                                      width: 120,
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Product"),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text("AED XXX"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[Text("Subtotal"), Text("AED 100")],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Delivery charge"),
                          Text("AED 10")
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[Text("Total"), Text("AED 110")],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  height = 150;
                });
                _controller.reverse().then((value) {
                  _trackNowStream.add(false);
                });
              },
              child: AnimatedContainer(
                duration: Duration(seconds: 2),
                color: Colors.white,
                height: height,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Order Status",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          FlatButton(
                            onPressed: () {
//                              _trackNowStream.add(true);
//
//                              setState(() {
//                                height = 400;
//                              });
//                              _controller.forward();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderTrackingPage()),
                              );
                            },
                            child: Text(
                              "Track Now",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (_, child) {
                          return Transform.translate(
                            offset: Offset(0.0, _controller.value * 100.0),
                            child: Transform.rotate(
                              angle: _controller.value * math.pi / 2,
                              child: child,
                            ),
                          );
                        },
                        child: StreamBuilder<bool>(
                            stream: _trackNowStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshot) {
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: OrderTrackingTimeLine(
                                    expand: true,
                                    rightItems: ["Packed", "", ""],
                                    showDescription: snapshot.data,
                                    hideElements: snapshot.data,
                                    topRowItems: ["Packed", "", ""],
                                    numberOfTrackLines: 3,
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Delivery address",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Address Line"),
                          Text("Street, City"),
                          Text("Country")
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Payment Method",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Cash on Delivery"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: RaisedButton(
                onPressed: () {},
                child: Text("CANCEL ORDER"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
