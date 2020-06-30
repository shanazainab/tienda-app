import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tienda/view/search/product-filter.dart';
import 'package:tienda/view/search/search-home-container.dart';
import 'package:tienda/view/search/search-video-result.dart';
import 'package:tienda/view/search/product-sort.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  PanelController sortPanelController = new PanelController();
  PanelController filterPanelController = new PanelController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return ProductSort();
                      });
                },
                child: Text("Sort"),
              ),
            ),
            Expanded(
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductFilter()),
                  );
                },
                child: Text("Filter"),
              ),
            )
          ],
        ),
        appBar: AppBar(
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.lightBlue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.lightBlue,
            tabs: [
              Tab(
                icon: Icon(Icons.line_style),
              ),
              Tab(icon: Icon(Icons.videocam)),
            ],
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                  hintText: "Search for brands & products",
                  hintStyle: TextStyle(fontSize: 12),
                  border: InputBorder.none),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8.0),
              child: Icon(
                Icons.keyboard_voice,
                size: 22,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Icon(
                Icons.camera_alt,
                size: 22,
              ),
            )
          ],
        ),
        body: TabBarView(
          children: [
            SearchHomeContainer(),
            SearchVideoResult(),
          ],
        ),
      ),
    );
  }
}
