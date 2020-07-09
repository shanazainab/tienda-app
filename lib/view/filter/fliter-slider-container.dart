import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tienda/model/Filter.dart';

class FilterSliderContainer extends StatefulWidget {
  final Filter filter;

  FilterSliderContainer({this.filter});

  @override
  _FilterSliderContainerState createState() => _FilterSliderContainerState();
}

class _FilterSliderContainerState extends State<FilterSliderContainer> {
  RangeValues rangeValues = RangeValues(0,10);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Random random = new Random();
    int min = widget.filter.minValue, max = widget.filter.maxValue;
    double minRange = (min + random.nextInt(max - min)) * random.nextDouble();
    double maxRange = (max - random.nextInt(max - min)) * random.nextDouble();

    print("$minRange ::: $maxRange");
    rangeValues = RangeValues(minRange, maxRange);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Select Price Range",
          style: TextStyle(
            color: Colors.grey
          ),),
          SizedBox(
            height: 16,
          ),
          Text("AED ${rangeValues.start.round()} - AED ${rangeValues.end.round()}",
          style: TextStyle(
            fontWeight: FontWeight.w500
          ),),
          RangeSlider(
            values: rangeValues,
            onChanged: (rangeValue) {
              setState(() {
                rangeValues = rangeValue;
              });
            },
            activeColor: Colors.pink,
            min: widget.filter.minValue.toDouble(),
            max: widget.filter.maxValue.toDouble(),
          ),
        ],
      ),
    );
  }
}
