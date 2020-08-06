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
          length: 3,
          child: new Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              title: Text(
                AppLocalizations.of(context).translate("orders"),
                style: TextStyle(color: Colors.black),
              ),
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
                      text: AppLocalizations.of(context)
                          .translate("in-process"),
                    ),
                    Tab(
                      text: AppLocalizations.of(context)
                          .translate("delivered"),
                    ),
                  ]),
            ),
            body: state is LoadOrderDataSuccess
                ? TabBarView(children: [
                    OrdersListContainer(state.allOrders),
                    OrdersListContainer(state.processingOrders),
                    OrdersListContainer(state.deliveredOrders),
                  ])
                : Container(),
          ));
    });
  }
}
