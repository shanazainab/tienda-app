import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tienda/view/products/product-list-page.dart';

class CategoriesPage extends StatelessWidget {
  final ScrollController subcategoryScroller = new ScrollController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
            child: Container(
              alignment: Alignment.center,
              color: Colors.grey[200],
              height: MediaQuery.of(context).size.height - 200,
              width: MediaQuery.of(context).size.width / 4 + 50,
              child: ListView.builder(
                  itemCount: 100,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          itemScrollController.scrollTo(
                              index: 5,
                              duration: Duration(seconds: 2),
                              curve: Curves.easeInOutCubic);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                border: index == 0
                                    ? Border(
                                        right: BorderSide(
                                            color: Colors.blue, width: 4))
                                    : Border()),
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'category',
                              style: TextStyle(fontSize: 16),
                            )),
                      ),
                    );
                  }),
            ),
          ),
          Container(
            width: 3 * MediaQuery.of(context).size.width / 4 - 50,
            child: ScrollablePositionedList.builder(
              padding: EdgeInsets.only(top: 100),
              itemCount: 100,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductListPage()),
                  );
                },
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Container(
                          height: 60,
                          width: 50,
                          color: Colors.grey[200],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('sub-category'),
                            Text(
                              'One short description',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ),
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
            ),
          ),

        ],
      ),
    );
  }
}
