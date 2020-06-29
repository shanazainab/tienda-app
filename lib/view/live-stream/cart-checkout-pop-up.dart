import 'package:flutter/material.dart';

class CartCheckOutPopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 3,
                width: 80,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Cart",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) => Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            color: Colors.grey[200],
                            height: 50,
                            width: 40,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text("Product Name"),
                                      Text("Description"),
                                      Text("Size: M"),
                                      Text("Color: Red")
                                    ],
                                  ),
                                  Text("X")
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text("Delete"),
                                  Text("Move to Wishlist")
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )),
          )
        ],
      ),
    );
  }
}
