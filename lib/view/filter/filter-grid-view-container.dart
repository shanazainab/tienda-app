import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:tienda/model/Filter.dart';

class FilterGridViewContainer extends StatelessWidget {

  final Filter filter;


  FilterGridViewContainer({this.filter});


  final double itemHeight = 40;
  final double itemWidth = 30;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top:16.0),
        child: GridView.builder(
          shrinkWrap: true,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 8,mainAxisSpacing: 8,

          childAspectRatio: itemWidth/itemHeight),
          itemBuilder: (_, index) =>Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
              ),
              Text(filter.subFilters[0].name + filter.subFilters[0].noOfProducts,
              style: TextStyle(
                fontSize: 12
              ),)
            ],
          ),
          itemCount: 6,
        ),
      ),
    );
  }
}
