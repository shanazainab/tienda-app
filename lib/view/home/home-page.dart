import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/loginMainPage');
        },
        child: Icon(Icons.account_circle),
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Text(
        'Home Page',
        style: TextStyle(fontSize: 24),
      )),
    );
  }
}
