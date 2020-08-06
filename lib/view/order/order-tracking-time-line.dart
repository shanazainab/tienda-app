import 'package:flutter/material.dart';

class OrderTrackingTimeLine extends StatefulWidget {
  final numberOfTrackLines;
  final List<String> topRowItems;

  OrderTrackingTimeLine({
    this.numberOfTrackLines,
    this.topRowItems,
  });

  @override
  _OrderTrackingTimeLineState createState() => _OrderTrackingTimeLineState();
}

class _OrderTrackingTimeLineState extends State<OrderTrackingTimeLine> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      alignment: Alignment.center,
      child: new ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.numberOfTrackLines,
          itemBuilder: (BuildContext ctxt, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.topRowItems[index],
                  style: TextStyle(fontSize: 12),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: widget.topRowItems[index] != ""
                          ? Colors.lightBlue
                          : Colors.grey,
                    ),
                    Container(
                      color: widget.topRowItems[index] != ""
                          ? Colors.lightBlue
                          : Colors.grey,
                      height: 2,
                      width: 80,
                    ),
                    index == widget.numberOfTrackLines - 1
                        ? CircleAvatar(
                            radius: 5,
                            backgroundColor: widget.topRowItems[index] != ""
                                ? Colors.lightBlue
                                : Colors.grey,
                          )
                        : Container(),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
