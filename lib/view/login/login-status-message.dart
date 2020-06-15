import 'package:flutter/material.dart';

class LoginErrorMessage extends StatelessWidget {
  final String message;

  LoginErrorMessage({this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      color: Colors.redAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left:16,right:16,top:8.0,bottom: 8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
