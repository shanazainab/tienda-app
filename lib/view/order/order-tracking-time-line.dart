import 'package:flutter/material.dart';
import 'dart:math' as math;

class OrderTrackingTimeLine extends StatefulWidget {
  final numberOfTrackLines;
  final List<String> topRowItems;
  final bool expand;
  final bool hideElements;
  final List<String> rightItems;
  final showDescription;

  OrderTrackingTimeLine(
      {this.numberOfTrackLines,
      this.topRowItems,
      this.expand,
      this.hideElements,
      this.rightItems,
      this.showDescription});

  @override
  _OrderTrackingTimeLineState createState() => _OrderTrackingTimeLineState();
}

class _OrderTrackingTimeLineState extends State<OrderTrackingTimeLine>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
Animation _animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    if (widget.showDescription) _controller.forward();
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
                if (!widget.hideElements)
                  Text(
                    widget.topRowItems[index],
                    style: TextStyle(fontSize: 12),
                  ),
                FadeTransition(
                  opacity: _animation,
                  child: Transform.rotate(
                    angle: -1.5708,
                    child: Text(
                      widget.topRowItems[index],
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
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
                      width: widget.expand ? 80 : 50,
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
