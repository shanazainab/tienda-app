import 'package:flutter/material.dart';

class EditCustomerProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 200,
                      color: Colors.grey[200],
                    ),
                    Container(
                      height: 50,
                      color: Colors.white,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.lightBlue,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0,top:24),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[100],
                      labelText: 'Name'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelText: 'Email'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelText: 'DOB'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text("SAVE"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
