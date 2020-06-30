import 'package:flutter/material.dart';

class OrderTrackingTimeLine extends StatelessWidget {
  final numberOfTrackLines;
  final List<String> bottomRowItems;
  final List<String> topRowItems;
  final bool expand;

  OrderTrackingTimeLine(
      {this.numberOfTrackLines, this.bottomRowItems, this.topRowItems,this.expand});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: new ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: numberOfTrackLines,
          itemBuilder: (BuildContext ctxt, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(topRowItems[index]),
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: topRowItems[index] != ""
                          ? Colors.lightBlue
                          : Colors.grey,
                    ),
                    Container(
                      color: topRowItems[index] != ""
                          ? Colors.lightBlue
                          : Colors.grey,
                      height: 2,
                      width: expand?80:50,
                    ),
                    index == numberOfTrackLines - 1
                        ? CircleAvatar(
                          radius: 5,
                          backgroundColor: topRowItems[index] != ""
                              ? Colors.lightBlue
                              : Colors.grey,
                        )
                        : Container(),
                  ],
                ),
                Text(bottomRowItems[index])
              ],
            );
          }),
    );
  }
}
