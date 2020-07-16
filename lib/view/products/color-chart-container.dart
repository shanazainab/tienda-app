import 'package:flutter/material.dart';

class ColorChartContainer extends StatelessWidget {
  final List<Color> colors = [Colors.black, Colors.deepOrangeAccent, Colors.lightBlue, Colors.limeAccent];

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
            Text("CHOOSE COLOR"),
            SizedBox(
              height: 100,
              child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: colors.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.only(right:16.0),
                    child: CircleAvatar(
                      backgroundColor:colors[index],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
