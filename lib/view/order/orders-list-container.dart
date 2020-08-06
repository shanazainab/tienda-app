import 'package:cached_network_image/cached_network_image.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/order-events.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/view/order/order-details-page.dart';

class OrdersListContainer extends StatelessWidget {
  final List<Order> orders;

  OrdersListContainer(this.orders);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrdersDetailsPage(orders[index])),
                  );
                },
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    shrinkWrap: true,
                    children: <Widget>[
                      Text(
                        "ORDER NO: ${orders[index].orderUuid}",
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              DateFormat('dd-MM-yyyy')
                                  .format(orders[index].createdAt),
                            ),
                            Text(
                              orders[index].status,
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      ListView.separated(
                          separatorBuilder:
                              (BuildContext context, int subIndex) => Divider(
                                    endIndent: 8,
                                    indent: 8,
                                  ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: orders[index].products.length,
                          itemBuilder: (BuildContext context, int subIndex) =>
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CachedNetworkImage(
                                        imageUrl: orders[index]
                                            .products[subIndex]
                                            .thumbnail,
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          color: Color(0xfff2f2e4),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              154,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                orders[index]
                                                    .products[subIndex]
                                                    .nameEn,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                    "AED ${orders[index].products[subIndex].price}"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),

                      orders[index].status == "pending"?Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: OutlineButton(
                          onPressed: (){
                            BlocProvider.of(context).add(CancelOrder(orders[index].id));
                          },
                          child: Text("CANCEL ORDER"),
                        ),
                      ):Container()
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
