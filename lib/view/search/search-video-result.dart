import 'package:flutter/material.dart';

class SearchVideoResult extends StatefulWidget {
  @override
  _SearchVideoResultState createState() => _SearchVideoResultState();
}

class _SearchVideoResultState extends State<SearchVideoResult> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) => Container(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(

                  ),
                ),
              )),
    );
  }
}
