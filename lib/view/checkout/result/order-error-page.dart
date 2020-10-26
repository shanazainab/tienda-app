import 'package:flutter/material.dart';
import 'package:tienda/view/home/page/main-screen.dart';

class OrderErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Oops Something went wrong'),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen()));
              },
              child: Text("Continue Shopping"),
            )
          ],
        )),
      ),
    );
  }
}
