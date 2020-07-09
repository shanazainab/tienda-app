import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/order/order-details-page.dart';
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
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("${AppLocalizations.of(context).translate("order-number")}: 1118979880"),
                    Text(AppLocalizations.of(context).translate("delivered")),
                  ],
                ),
                Divider(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrdersDetailsPage()),
                    );
                  },
                  child: Row(
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - (24 * 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[Text(AppLocalizations.of(context).translate("ordered")), Text("18 Jun")],
                        ),
                        OrderTrackingTimeLine(
                          expand: false,
                          topRowItems: ["", "", ""],
                          numberOfTrackLines: 3,
                          bottomRowItems: ["", "", ""],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[Text(AppLocalizations.of(context).translate("delivery")), Text("05 Jul")],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
