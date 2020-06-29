import 'package:flutter/material.dart';
import 'package:tienda/view/seller-profile/seller-product-video-page.dart';

class SellerProfilesListView extends StatelessWidget {
  final List<Tab> myTabs = <Tab>[
    Tab(
      text: 'ALL',
    ),
    Tab(text: 'CATEGORY 1'),
    Tab(text: 'CATEGORY 2'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            bottom: TabBar(
              unselectedLabelStyle: TextStyle(color: Colors.lightBlue),
              unselectedLabelColor: Colors.lightBlue,
              labelStyle: TextStyle(color: Colors.grey),
              labelColor: Colors.grey,
              tabs: myTabs,
            ),
          ),
          body: TabBarView(
            children: myTabs.map((Tab tab) {
              return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                height: 100,
                                width: 80,
                                color: Colors.grey[200],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Seller name",
                                  ),
                                  Text(
                                    "One line description",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        index / 2 == 0
                            ? RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SellerProductVideoPage()),
                                  );
                                },
                                color: Colors.blue,
                                child: Text('JOIN',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                              )
                            : RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                onPressed: () {},
                                color: Colors.grey,
                                child: Text(
                                  'MESSAGE',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              });
            }).toList(),
          ),
        ),
      ),
    );
  }
}
