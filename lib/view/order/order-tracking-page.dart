import 'package:flutter/material.dart';

class OrderTrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text("Order No"), Text("121324343")],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text("Tracking No"), Text("121324343")],
                  ),
                ),

              ],
            ),
            SizedBox(height: 20,),
            ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 8,
                            ),
                            Container(
                              color: Colors.grey,
                              width: 2,
                              height: 100,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Package arrived at center")
                      ],
                    )),
          ],
        ),
      ),
    );
  }
}
