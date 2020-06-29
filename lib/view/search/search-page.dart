import 'package:flutter/material.dart';
import 'package:tienda/view/search/search-home-container.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            bottom: TabBar(
              labelColor: Colors.lightBlue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.lightBlue,
              tabs: [
                Tab(icon: Icon(Icons.line_style),
                ),
                Tab(icon: Icon(Icons.videocam)),
              ],
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(


                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8, top: 0, bottom: 0),
                    filled: true,
                    prefixIcon: Icon(Icons.search,
                    color: Colors.grey,),
                    fillColor: Colors.grey[200],
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusColor: Colors.grey[200],
                    hintText: "Search for brands & products",
                    hintStyle: TextStyle(
                      fontSize: 12
                    ),
                    border: InputBorder.none),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:8,right: 8.0),
                child: Icon(Icons.keyboard_voice,
                size: 22,),
              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0,right: 8.0),
                child: Icon(Icons.camera_alt,
                size: 22,),
              )
            ],
          ),
          body: TabBarView(
            children: [
              SearchHomeContainer(),
              Icon(Icons.directions_transit),
            ],
          ),
      ),
    );
  }
}
