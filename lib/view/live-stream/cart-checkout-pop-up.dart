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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Cart",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)
                  ),
                  color: Colors.lightBlue,
                  onPressed: () {},
                  child: Text("Checkout",
                  style: TextStyle(
                    color: Colors.white
                  ),),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.all(4),
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) => Container(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Spacer(
                              flex: 2,
                            ),
                            Container(
                              color: Colors.grey[200],
                              height: 100,
                              width: 80,
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text("Product Name"),
                                Text("Description"),
                                Text("Size: M"),
                                Text("Color: Red"),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Delete",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          "Move to Wishlist",
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Text("AED XXX"),
                            Spacer(
                              flex: 2,
                            ),
                          ],
                        ),
                      ),
                    )),
          )
        ],
      ),
    );
  }
}
