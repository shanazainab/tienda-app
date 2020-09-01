import 'package:flutter/material.dart';
import 'package:tienda/view/search/popular-search-block.dart';
import 'package:tienda/view/search/recent-search-block.dart';

typedef ScrollCallBack = Function(String status);

class SearchHomeContainer extends StatelessWidget {
  final ScrollCallBack onScroll;

  SearchHomeContainer({this.onScroll});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: NotificationListener<ScrollNotification>(
        onNotification: (status) {
          if (status is ScrollNotification) {
            onScroll("START");
          }
          if (status is ScrollEndNotification) {
            onScroll("END");
          }

          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[RecentSearchBlock(),
              //PopularSearchBlock()
           ],
          ),
        ),
      ),
    );
  }
}
