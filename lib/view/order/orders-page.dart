import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tienda/view/order/order-tracking-time-line.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: ListView(
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Order No: 1118979880"),
                    Text("DELIVERED"),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: "https://picsum.photos/250?image=9",
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Color(0xfff2f2e4),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("Brand name"),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text("Description"),
                          ),
                          Row(
                            children: <Widget>[
                              Text('Qty: 1'),
                              Text(" | "),
                              Text('Size: 39')
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text("AED 500"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[Text("Ordered"), Text("18 Jun")],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 400,
                      child: OrderTrackingTimeLine(
                        orderStatus: "Packed",
                      ),
                    ),
                    Container(
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[Text("Delivery"), Text("05 Jul")],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
