import 'package:flutter/material.dart';

class ProductSort extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Sort by",style: TextStyle(
              fontSize: 16
            ),),
          ),
          Divider(
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            title: Text("What's new"),
          ),
          ListTile(
            title: Text("Popularity"),
          ),
          ListTile(
            title: Text("Discount"),
          ),
          ListTile(
            title: Text("Price low to high"),
          ),
          ListTile(
            title: Text("Price high to low"),
          )
        ],
      ),
    );
  }
}
