import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/order-events.dart';
import 'package:tienda/bloc/orders-bloc.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/view/order/order-cancel-page.dart';
import 'package:tienda/view/order/order-tracking-page.dart';
import 'package:tienda/view/order/order-tracking-time-line.dart';
import 'package:tienda/view/products/single-product-page.dart';
import 'package:transparent_image/transparent_image.dart';

class OrdersDetailsPage extends StatelessWidget {
  final Order order;

  OrdersDetailsPage(this.order);

  @override
  Widget build(BuildContext contextA) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(contextA).translate("order-details")),
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
                padding: const EdgeInsets.all(16.0),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(contextA).translate('order-number')}: ",
                            maxLines: 1,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${order.orderUuid}",
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    contextA,
                                    MaterialPageRoute(
                                        builder: (context) => SingleProductPage(
                                            order.products[index].id)),
                                  );
                                },
                                child: Container(
                                  height: 160,
                                  width: 120,
                                  child: Stack(
                                    children: <Widget>[
                                      FadeInImage.memoryNetwork(
                                        image: order.products[index].thumbnail,
                                        height: 160,
                                        width: 120,
                                        fit: BoxFit.cover,
                                        placeholder: kTransparentImage,

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
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  "${AppLocalizations.of(contextA).translate('aed')} ${order.products[index].price}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                        AppLocalizations.of(contextA)
                            .translate("price-details"),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(AppLocalizations.of(contextA)
                            .translate("subtotal")),
                        Text(
                            "${AppLocalizations.of(contextA).translate("aed")} ${order.totalPrice}")
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(AppLocalizations.of(contextA)
                              .translate("total-discount")),
                          Text(
                              "${AppLocalizations.of(contextA).translate("aed")} 0")
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(AppLocalizations.of(contextA)
                              .translate("delivery-charge")),
                          Text(
                              "${AppLocalizations.of(contextA).translate("aed")} 0")
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                              AppLocalizations.of(contextA).translate("total")),
                          Text(
                              "${AppLocalizations.of(contextA).translate("aed")} ${order.totalPrice}")
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
                          AppLocalizations.of(contextA)
                              .translate("order-status"),
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
                      AppLocalizations.of(contextA)
                          .translate("delivery-address"),
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
                      AppLocalizations.of(contextA).translate("payment-method"),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(AppLocalizations.of(contextA)
                          .translate("cash-on-delivery")),
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
                                  child: Text(AppLocalizations.of(contextA)
                                      .translate("return-order")
                                      .toUpperCase()),
                                ),
                              )
                            : Container(),
                        order.status == "pending" ||
                                (order.status != "delivered" &&
                                    order.status != "canceled")
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: OutlineButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      contextA,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider.value(
                                                value:
                                                    BlocProvider.of<OrdersBloc>(
                                                        contextA),
                                                child: OrderCancelPage(order),
                                              )),
                                    );
                                  },
                                  child: Text(AppLocalizations.of(contextA)
                                      .translate("cancel-order")
                                      .toUpperCase()),
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
