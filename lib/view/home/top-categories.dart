import 'package:flutter/material.dart';

class TopCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "Top Categories",
          style: TextStyle(fontSize: 20, color: Colors.lightBlue),
        ),
        GridView.builder(
          padding: EdgeInsets.all(16),
          shrinkWrap: true,
          physics: ScrollPhysics(),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (_, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
            ),
          ),
          itemCount: 9,
        ),
      ],
    );
  }
}
