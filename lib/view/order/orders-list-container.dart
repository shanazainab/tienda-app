import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/orders-bloc.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/order.dart';
import 'package:tienda/view/order/order-details-page.dart';
import 'package:transparent_image/transparent_image.dart';

class OrdersListContainer extends StatelessWidget {
  final BuildContext contextA;
  final List<Order> orders;
  final String type;

  OrdersListContainer(this.contextA, this.orders, this.type);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Container(
      color: Colors.grey[200],
      child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (BuildContext context, int index) {
            return type == "all" || orders[index].status == type
                ? Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          contextA,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                    value:
                                        BlocProvider.of<OrdersBloc>(contextA),
                                    child: OrdersDetailsPage(orders[index]),
                                  )),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(16),
                          shrinkWrap: true,
                          children: <Widget>[
                            ///  order-number
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context).translate('order-number')}: ",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    "${orders[index].orderUuid}",
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    new DateFormat.yMMMMd('en_US')
                                        .format(orders[index].createdAt),
                                  ),
                                  Text(
                                    orders[index].status.toUpperCase(),
                                    style: TextStyle(
                                        color:
                                            orders[index].status == "canceled"
                                                ? Colors.redAccent
                                                : Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int subIndex) =>
                                        Divider(
                                          endIndent: 8,
                                          indent: 8,
                                        ),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: orders[index].products.length,
                                itemBuilder: (BuildContext context,
                                        int subIndex) =>
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            FadeInImage.memoryNetwork(
                                              image: orders[index]
                                                  .products[subIndex]
                                                  .thumbnail,
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover,
                                              placeholder: kTransparentImage,

                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
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
                                                      appLanguage.appLocal ==
                                                              Locale("en")
                                                          ? orders[index]
                                                              .products[
                                                                  subIndex]
                                                              .nameEn
                                                          : orders[index]
                                                              .products[
                                                                  subIndex]
                                                              .nameAr,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Text(
                                                          "${AppLocalizations.of(context).translate('aed')} ${orders[index].products[subIndex].price}"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container();
          }),
    );
  }
}
