import 'package:flutter/material.dart';

class AddToCartPopUp extends StatelessWidget {
  final List<String> sizeChart = ['S', 'M', 'L', 'XL'];

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              height: 3,
              width: 80,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              height: 100,
              width: 200,
              color: Colors.grey[200],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(flex: 2, child: Container()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[Text("Product name"), Text("description")],
                ),
                Flexible(flex: 1, child: Container()),
                Text("AED XXX"),
                Flexible(flex: 2, child: Container()),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Spacer(
                flex: 2,
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 100,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: sizeChart.length,
                        itemBuilder: (BuildContext context, int index) =>
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                radius: 10,
                                child: Text(sizeChart[index]),
                              ),
                            )),
                  ),
                ],
              ),
              Spacer(
                flex: 1,
              ),
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.blue,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.black,
                    ),
                  ),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
          RaisedButton(
            onPressed: () {},
            child: Text("ADD TO CART"),
          )
        ]);
  }
}
