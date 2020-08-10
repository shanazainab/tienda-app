import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/order-events.dart';
import 'package:tienda/bloc/orders-bloc.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/view/order/order-cancel-page.dart';
import 'package:tienda/view/order/order-tracking-page.dart';
import 'package:tienda/view/order/order-tracking-time-line.dart';


class OrdersDetailsPage extends StatelessWidget {
  final Order order;

  OrdersDetailsPage(this.order);

  @override
  Widget build(BuildContext contextA) {
    return Scaffold(
      appBar:AppBar(
        title: Text("ORDER DETAILS"),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(contextA).size.width,
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
                              contextA,
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
                width: MediaQuery.of(contextA).size.width,
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
                width: MediaQuery.of(contextA).size.width,
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
              Container(
                width: MediaQuery.of(contextA).size.width,
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        order.status == "delivered"
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: OutlineButton(
                                  onPressed: () {
                                    BlocProvider.of<OrdersBloc>(contextA)
                                        .add(ReturnOrder(order));
                                  },
                                  child: Text("RETURN ORDER"),
                                ),
                              )
                            : Container(),
                        order.status == "pending" || (order.status != "delivered" && order.status != "canceled")
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: OutlineButton(
                                  onPressed: () {



                                    Navigator.pushReplacement(
                                      contextA,
                                      MaterialPageRoute(
                                          builder: (context) => BlocProvider.value(
                                            value: BlocProvider.of<OrdersBloc>(contextA),
                                            child: OrderCancelPage(order),
                                          )),
                                    );


                                  },
                                  child: Text("CANCEL ORDER"),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
