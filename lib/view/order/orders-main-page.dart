import 'package:flutter/material.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/order/orders-page.dart';

class OrdersMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            title: Text(AppLocalizations.of(context).translate("orders")),
            centerTitle: true,
            bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.blue,
                labelColor: Colors.grey,
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle: TextStyle(color: Colors.grey),
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context).translate("all"),
                  ),
                  Tab(
                    text: AppLocalizations.of(context).translate("in-process"),
                  ),
                  Tab(
                    text: AppLocalizations.of(context).translate("delivered"),
                  ),
                ]),
          ),
          body: TabBarView(children: [
            OrdersPage(),
            OrdersPage(),
            OrdersPage(),
          ]),
        ));
  }
}
