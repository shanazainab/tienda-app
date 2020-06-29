import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ReturnsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RETURNS"),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: ListView(
                padding: EdgeInsets.all(16),
                shrinkWrap: true,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: "https://picsum.photos/250?image=9",
                          width: 110,
                          height: 130,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Color(0xfff2f2e4),
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Brand name"),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text("Description"),
                              ),
                              Row(
                                children: <Widget>[
                                  Text('Qty: 1'),
                                  Text(" | "),
                                  Text('Size: 39')
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text("AED 500"),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
