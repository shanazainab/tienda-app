import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  final ScrollController subcategoryScroller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            color: Colors.grey[200],
            height: MediaQuery.of(context).size.height - 200,
            width: MediaQuery.of(context).size.width / 4,
            child: ListView.builder(
                itemCount: 100,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text('category'));
                }),
          ),
          Container(
            width: 3 * MediaQuery.of(context).size.width / 4,
            child: ListView.builder(
                controller: subcategoryScroller,
                itemCount: 100,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Container(
                      alignment: Alignment.center,
                      height: 20,
                      child: Text('sub-category'));
                }),
          )
        ],
      ),
    );
  }
}
