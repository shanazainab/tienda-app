import 'package:flutter/material.dart';

class FollowingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text('Following'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 16,
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minHeight: 32,
                      minWidth: 32,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[200])),
                    isDense: true,
                    fillColor: Colors.grey[200],
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusColor: Colors.grey[200],
                    hintText:'Search name',
                    hintStyle: TextStyle(fontSize: 12),
                    border: InputBorder.none),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 120,
                                  width: 90,
                                  color: Colors.grey[200],
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text("Seller name"),
                                      Icon(
                                        Icons.verified_user,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                  Text(
                                    "About: Short bio for seller",
                                    style:
                                        TextStyle(color: Colors.grey, fontSize: 12),
                                  )
                                ],
                              )
                            ],
                          ),
                          if (index == 1)
                            RaisedButton(
                              color: Colors.lightBlue,
                              onPressed: () {},
                              child: Text("message"),
                            )
                        ],
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}
