import 'package:flutter/material.dart';
import 'package:tienda/view/checkout/cart-page.dart';

class CartReminderDialogue extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 200,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.clear),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                "You Shopping Bag is Waiting",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16.0),
              child: RaisedButton(
                child: Text("GO CHECKOUT"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CartPage()),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
