import 'package:flutter/material.dart';

class CategoryBlock extends StatelessWidget {
  const CategoryBlock({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
              ),
            );
          }
      ),
    );
  }
}