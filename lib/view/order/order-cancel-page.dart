import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/order-events.dart';
import 'package:tienda/bloc/orders-bloc.dart';
import 'package:tienda/model/order.dart';

class OrderCancelPage extends StatefulWidget {
  final Order order;

  OrderCancelPage(this.order);

  @override
  _OrderCancelPageState createState() => _OrderCancelPageState();
}

class _OrderCancelPageState extends State<OrderCancelPage> {
  List<String> options = [
    'Incorrect Product or Size Ordered',
    'Product no longer needed',
    'Product does not match description',
    'Did not meet the expectation'
  ];

  int radioValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cancel Order",
        ),
        centerTitle: false,
      ),
      body: _body(),
    );
    //
  }

  Widget _body() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) => Row(
              children: [
                Radio(
                  value: index,
                  groupValue: radioValue,
                  onChanged: (value) {
                    setState(() {
                      radioValue = value;
                      print(radioValue);
                    });
                  },
                  activeColor: Colors.black,
                ),
                Text(options[index]),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: RaisedButton(
                onPressed: () {
                  BlocProvider.of<OrdersBloc>(context)
                      .add(CancelOrder(widget.order));
                  BlocProvider.of<OrdersBloc>(context).add(LoadOrders());
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "CANCEL ORDER",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
