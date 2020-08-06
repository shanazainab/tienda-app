import 'package:flutter/material.dart';
import 'package:tienda/model/product-list-response.dart';

typedef void IsFilterChosen(bool isChosen);

class FilterSliderContainer extends StatefulWidget {
  final Filter filter;
  final IsFilterChosen isFilterChosen;

  FilterSliderContainer({this.filter, this.isFilterChosen});

  @override
  _FilterSliderContainerState createState() => _FilterSliderContainerState();
}

class _FilterSliderContainerState extends State<FilterSliderContainer> {
  RangeValues rangeValues = RangeValues(0, 10);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.filter.values[0].chosenMinPrice == null &&
        widget.filter.values[0].chosenMaxPrice == null)
      rangeValues = RangeValues(
          widget.filter.values[0].minPrice, widget.filter.values[0].maxPrice);
    else if (widget.filter.values[0].chosenMinPrice != null &&
        widget.filter.values[0].chosenMaxPrice != null)
      rangeValues = RangeValues(widget.filter.values[0].chosenMinPrice,
          widget.filter.values[0].chosenMaxPrice);
    else if (widget.filter.values[0].chosenMinPrice != null &&
        widget.filter.values[0].chosenMaxPrice == null)
      rangeValues = RangeValues(widget.filter.values[0].chosenMinPrice,
          widget.filter.values[0].maxPrice);
    else if (widget.filter.values[0].chosenMinPrice == null &&
        widget.filter.values[0].chosenMaxPrice != null)
      rangeValues = RangeValues(widget.filter.values[0].minPrice,
          widget.filter.values[0].chosenMaxPrice);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Select Price Range",
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "AED ${rangeValues.start.round()} - AED ${rangeValues.end.round()}",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          RangeSlider(
            values: rangeValues,
            onChanged: (rangeValue) {
              setState(() {
                rangeValues = rangeValue;
              });

              widget.filter.values[0].chosenMinPrice = rangeValue.start;
              widget.filter.values[0].chosenMaxPrice = rangeValue.end;

              if (widget.filter.values[0].chosenMinPrice != null ||
                  widget.filter.values[0].chosenMaxPrice != null) {
                widget.isFilterChosen(true);
                widget.filter.chosen = true;
              } else {
                widget.isFilterChosen(false);
                widget.filter.chosen = false;
              }
            },
            activeColor: Colors.pink,
            min: widget.filter.values[0].minPrice,
            max: widget.filter.values[0].maxPrice,
          ),
        ],
      ),
    );
  }
}
