import 'package:flutter/material.dart';
import 'package:tienda/view/home/home-page-appbar.dart';

class TiendaHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // here the desired height

          child: HomePageAppbar()),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Text(
            "HOME PAGE",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
