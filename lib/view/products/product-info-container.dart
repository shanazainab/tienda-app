import 'package:flutter/material.dart';

class ProductInfoContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Brand",style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
            Text("Product Name"),
            Padding(
              padding: const EdgeInsets.only(top:4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('AED 714',style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0,right: 8.0),
                    child: Text(
                      'AED 1299',

                      style: TextStyle(decoration: TextDecoration.lineThrough,
                      color: Colors.grey),
                    ),
                  ),
                  Text(
                    '(45% OFF)',
                    style: TextStyle(color: Colors.red),
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text(
                "inclusive of all taxes",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            )
          ],
        ),
      ),
    );
  }
}
