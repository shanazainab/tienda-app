import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/orders-bloc.dart';
import 'package:tienda/bloc/states/order-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/order/orders-list-container.dart';

class OrdersMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrderStates>(builder: (context, state) {
      return DefaultTabController(
          length: 4,
          child: new Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              title: Text(
                AppLocalizations.of(context).translate("orders").toUpperCase(),
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.blue,
                  labelColor: Colors.grey,
                  labelStyle: TextStyle(
                    fontSize: 12
                  ),
                  unselectedLabelColor: Colors.grey,
                  unselectedLabelStyle: TextStyle(color: Colors.grey),
                  tabs: [
                    Tab(
                      text: AppLocalizations.of(context).translate("all"),
                    ),
                    Tab(
                      text: AppLocalizations.of(context).translate("delivered"),
                    ),
                    Tab(
                      text: 'CANCELED',
                    ),
                    Tab(
                      text: 'RETURNS',
                    ),
                  ]),
            ),
            body: state is LoadOrderDataSuccess
                ? TabBarView(children: [
                    OrdersListContainer(context,state.allOrders, "all"),
              OrdersListContainer(context,state.allOrders, 'canceled'),
                    OrdersListContainer(context,state.allOrders, 'delivered'),
              OrdersListContainer(context,state.allOrders, 'return-_request'),

            ])
                : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Center(
                child: Container(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),

            ),
          ));
    });
  }
}
