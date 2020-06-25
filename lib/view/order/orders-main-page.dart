import 'package:flutter/material.dart';
import 'package:tienda/view/order/orders-page.dart';

class OrdersMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: AppBar(
            title: Text('ORDERS'),
            centerTitle: true,
            bottom: TabBar(
              isScrollable: true,
                indicatorColor: Colors.blue,
                labelColor: Colors.grey,
                unselectedLabelColor: Colors.grey,

                unselectedLabelStyle: TextStyle(color: Colors.grey),
                tabs: [
                  Tab(
                    text: "ALL",
                  ),
                  Tab(
                    text: "IN PROCESS",
                  ),
                  Tab(
                    text: "DELIVERED",
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
