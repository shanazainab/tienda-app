import 'package:flutter/material.dart';
import 'package:tienda/view/home/home-screen.dart';

class OrderSuccessPage extends StatelessWidget {
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
            Text('ORDER SUCCESS'),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen()));
              },
              child: Text("Continue Shopping"),
            )
          ],
        )),
      ),
    );
  }
}
