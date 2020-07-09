import 'package:flutter/material.dart';
import 'package:tienda/model/Filter.dart';

class FilterListViewSearchContainer extends StatelessWidget {
  final Filter filter;

  FilterListViewSearchContainer({this.filter});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  filled: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 16,
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minHeight: 32,
                    minWidth: 32,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[200])),
                  isDense: true,
                  fillColor: Colors.grey[200],
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[200])),
                  focusColor: Colors.grey[200],
                  hintStyle: TextStyle(fontSize: 12),
                  border: InputBorder.none),
            ),
          ),
          ListView.separated(
            separatorBuilder:  (_, index) => Divider(
              indent: 16,
                endIndent: 16,
              height: 0,
            ),
            shrinkWrap: true,
            itemBuilder: (_, index) => ListTile(
 contentPadding: EdgeInsets.only(top:0,bottom: 0,left: 16,right:16),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.check,
                    size: 16,),
                  ],
                ),
                trailing: Text(filter.subFilters[0].noOfProducts,
                  style: TextStyle(fontSize: 12),),
                title: Text(
                  filter.subFilters[0].name,
                  style: TextStyle(fontSize: 12),
                )),
            itemCount: 6,
          ),
        ],
      ),
    );
  }
}
