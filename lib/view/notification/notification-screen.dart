import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text("Notification"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text('No notification'),
      ),
    );
  }
}
