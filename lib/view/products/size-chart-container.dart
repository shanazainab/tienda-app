import 'package:flutter/material.dart';

class SizeChartContainer extends StatelessWidget {
  final List<String> sizes = ['28', '30', '32', '34'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

      height: 160,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("CHOOSE SIZE"),
            SizedBox(
              height: 100,
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                  itemCount: sizes.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.only(right:16.0),
                    child: CircleAvatar(
                          child: Text(sizes[index]),
                          backgroundColor: Colors.grey[200],
                        ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
