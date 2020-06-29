import 'package:flutter/material.dart';
import 'package:tienda/view/search/popular-search-block.dart';
import 'package:tienda/view/search/recent-search-block.dart';

class SearchHomeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[RecentSearchBlock(), PopularSearchBlock()],
        ),
      ),
    );
  }
}
