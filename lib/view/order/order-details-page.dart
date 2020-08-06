import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/view/order/order-tracking-page.dart';
import 'package:tienda/view/order/order-tracking-time-line.dart';

import 'package:tienda/view/widgets/custom-app-bar.dart';

class OrdersDetailsPage extends StatelessWidget {
  final Order order;

  OrdersDetailsPage(this.order);

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
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(24.0),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Text("ORDER NO: ${order.orderUuid}"),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: 160,
                      alignment: Alignment.bottomLeft,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: order.products.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                height: 160,
                                width: 120,
                                child: Stack(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      imageUrl: order.products[index].thumbnail,
                                      height: 160,
                                      width: 120,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Color(0xfff2f2e4),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
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
                                            Text(
                                              order.products[index].nameEn,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                "AED ${order.products[index].price}",
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                    top: 16, left: 24, right: 24.0, bottom: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Price Details",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Subtotal"),
                        Text("AED ${order.totalPrice}")
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Total Discount"),
                          Text("AED 0")
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Delivery charge"),
                          Text("AED 0")
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Total"),
                          Text("AED ${order.totalPrice}")
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                    top: 16, left: 24, right: 24.0, bottom: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    OrderTrackingTimeLine(
                      topRowItems: ["Packed", "", ""],
                      numberOfTrackLines: 3,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                    top: 16, left: 24, right: 24.0, bottom: 16),
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
                          Text(order.addressData),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: const EdgeInsets.only(
                    top: 16, left: 24, right: 24.0, bottom: 16),
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
                      child: Text("Cash on Delivery"),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text("CANCEL ORDER"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
