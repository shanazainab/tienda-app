import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Text(
          "HOME PAGE",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
