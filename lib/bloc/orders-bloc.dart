import 'dart:convert';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/orders-api-client.dart';
import 'package:tienda/bloc/events/order-events.dart';
import 'package:tienda/bloc/states/order-states.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/order.dart';

class OrdersBloc extends Bloc<OrderEvents, OrderStates> {
  OrdersBloc() : super(Loading());

  @override
  Stream<OrderStates> mapEventToState(OrderEvents event) async* {
    if (event is LoadOrders) {
      yield* _mapOrdersToStates(event);
    }
    if (event is CancelOrder) {
      yield* _mapCancelOrderToStates(event);
    }
    if (event is ReturnOrder) {
      yield* _mapReturnOrderToStates(event);
    }

    if (event is FetchReturnOrders) {
      yield* _mapReturnsToStates(event);
    }
  }

  Stream<OrderStates> _mapReturnOrderToStates(ReturnOrder event) async* {
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;

    OrdersApiClient ordersApiClient = OrdersApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await ordersApiClient.returnOrder(event.order.id).then((response) {
      Logger().d("RETURN-ORDER-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("RETURN-ORDER-ERROR:", error);
      }
    });
  }

  Stream<OrderStates> _mapCancelOrderToStates(CancelOrder event) async* {
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;

    OrdersApiClient ordersApiClient = OrdersApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await ordersApiClient.cancelOrder(event.order.id).then((response) {
      Logger().d("CANCEL-ORDER-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("CANCEL-ORDER-ERROR:", error);
      }
    });
  }

  Stream<OrderStates> _mapOrdersToStates(LoadOrders event) async* {
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;

    List<Order> orders;

    OrdersApiClient ordersApiClient = OrdersApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await ordersApiClient.getOrders().then((response) {
      log("GET-ORDERS-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          orders = orderFromJson(json.encode(json.decode(response)['orders']));
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET-ORDERS-ERROR:", error);
      }
    });

    Logger().d("ORDER DATA: $orders");

    if (orders != null)
      yield LoadOrderDataSuccess(
        allOrders: orders,
      );
  }

  Stream<OrderStates> _mapReturnsToStates(FetchReturnOrders event) async* {
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;

    List<Order> orders;

    OrdersApiClient ordersApiClient = OrdersApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await ordersApiClient.getOrders().then((response) {
      Logger().d("GET-ORDERS-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          orders = orderFromJson(json.encode(json.decode(response)['orders']));
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET-ORDERS-ERROR:", error);
      }
    });

    Logger().d("ORDER DATA: $orders");
    List<Order> returnOrders = new List();

    for (final order in orders) {
      if (order.status == 'request_return') {
        returnOrders.add(order);
      }
    }
    if (returnOrders != null) yield FetchReturnOrdersSuccess(returnOrders);
  }
}
