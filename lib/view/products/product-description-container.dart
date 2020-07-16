import 'package:flutter/material.dart';

class ProductDescriptionContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        //height: 300,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("PRODUCT DESCRIPTION"),
              Center(
                child: TabBar(
                  labelPadding: EdgeInsets.only(left: 16, right: 16),
                  isScrollable: false,
                  indicatorColor: Colors.blue,
                  labelColor: Colors.grey,
                  labelStyle: TextStyle(),
                  unselectedLabelColor: Colors.grey,
                  unselectedLabelStyle: TextStyle(color: Colors.grey),
                  tabs: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      alignment: Alignment.center,
                      child: Tab(
                        text: 'Seller',
                      ),
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Tab(
                          text: 'Description',
                        )),
                  ],
                ),
              ),
              Container(
                height: 200,
                child: TabBarView(
                  children: [
                    Center(child: Text('SELLER INFO')),
                    Center(child: Text('PRODUCT INFO')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
