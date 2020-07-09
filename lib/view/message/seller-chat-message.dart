import 'package:flutter/material.dart';

class SellerDirectMessage extends StatefulWidget {
  @override
  _SellerDirectMessageState createState() => _SellerDirectMessageState();
}

class _SellerDirectMessageState extends State<SellerDirectMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        title: Text("seller name"),
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Icon(Icons.camera_alt),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left:16.0,right: 16,bottom: 8),
              child: TextField(
                decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[200])),
                    isDense: true,
                    fillColor: Colors.grey[200],
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusColor: Colors.grey[200],
                    hintText: "Type your message..",
                    hintStyle: TextStyle(fontSize: 12),
                    border: InputBorder.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: Icon(Icons.send),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
         reverse: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                  ),
                  Flexible(
                    child: Card(
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("This is a sample message,This is a sample message,This is a sample message,This is a sample message,This is a sample message,This is a sample message,This is a sample message, "),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Card(
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("This is a sample message"))
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
