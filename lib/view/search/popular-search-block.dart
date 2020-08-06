import 'package:flutter/material.dart';

class PopularSearchBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Popular on Tienda",
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) => Divider(
                    indent: 16,
                    endIndent: 16,
                  ),
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) => ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                    ),
                    title: Text("Brand"),
                    subtitle: Text("Category"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ))
        ],
      ),
    );
  }
}
