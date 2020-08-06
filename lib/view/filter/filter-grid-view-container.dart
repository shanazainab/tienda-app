import 'package:flutter/material.dart';
import 'package:tienda/model/product-list-response.dart';

class FilterGridViewContainer extends StatefulWidget {
  final Filter filter;

  FilterGridViewContainer({this.filter});

  @override
  _FilterGridViewContainerState createState() =>
      _FilterGridViewContainerState();
}

class _FilterGridViewContainerState extends State<FilterGridViewContainer> {
  final double itemHeight = 40;
  final double itemWidth = 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: itemWidth / itemHeight),
          itemBuilder: (_, index) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
              ),
              Text(
                "test",
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
          itemCount: 6,
        ),
      ),
    );
  }
}
