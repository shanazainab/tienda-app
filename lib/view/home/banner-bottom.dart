import 'package:flutter/material.dart';

class BannerBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
          itemCount: 3,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 3 / 4,
                  color: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Banner Title",
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          "Lorem pasm",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
          )),
    );
  }
}
