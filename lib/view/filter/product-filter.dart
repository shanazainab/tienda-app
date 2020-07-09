import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/model/Filter.dart';
import 'package:tienda/view/filter/filter-grid-view-container.dart';
import 'package:tienda/view/filter/filter-listview-search-container.dart';
import 'package:tienda/view/filter/fliter-slider-container.dart';

class ProductFilterUI {
  static const int GRID_VIEW = 0;
  static const int LIST_VIEW = 1;
  static const int SLIDER_VIEW = 3;
  Filter filter;
  int type;

  ProductFilterUI({this.filter, this.type});
}

class ProductFilter extends StatefulWidget {
  @override
  _ProductFilterState createState() => _ProductFilterState();
}

class _ProductFilterState extends State<ProductFilter> {
  final selectedFilter = BehaviorSubject<ProductFilterUI>();

  List<Filter> filters = [
    Filter(name: 'Seller', isFilterApplied: false, subFilters: [
      SubFilter(name: "seller", noOfProducts: "3"),
    ]),
    Filter(name: 'Brand', isFilterApplied: false, subFilters: [
      SubFilter(name: "brand", noOfProducts: "2"),
    ]),
    Filter(name: 'Price', isFilterApplied: false,   minValue: 20,
        maxValue: 200
    ),
    Filter(name: 'Color', isFilterApplied: false, subFilters: [
      SubFilter(name: "color", noOfProducts: "2"),
    ]),
    Filter(name: 'Size', isFilterApplied: false, subFilters: [
      SubFilter(name: "size", noOfProducts: "2"),
    ]),
    Filter(name: 'Discount', isFilterApplied: false, subFilters: [
      SubFilter(name: "discount", noOfProducts: "2"),
    ])
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedFilter.add(
        ProductFilterUI(filter: filters[0], type: ProductFilterUI.GRID_VIEW));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        title: Text("Filters"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Text(
              "CLEAR ALL",
              style: TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              child: Text('CANCEL'),
            ),
          ),
          Expanded(
            child: FlatButton(
              child: Text('APPLY'),
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.grey[200],
              width: MediaQuery.of(context).size.width / 4 + 50,
              child: ListView.builder(
                itemCount: filters.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () {
                    setState(() {
                      filters[index].isFilterApplied = true;

                      for (int i = 0; i < filters.length; ++i) {
                        if (index != i) {
                          filters[i].isFilterApplied = false;
                        }
                      }
                      print(filters);
                    });

                    int type;
                    switch (filters[index].name) {
                      case "Seller":
                      case 'Color':
                      case 'Size':
                        type = ProductFilterUI.GRID_VIEW;
                        break;
                      case 'Brand':

                      case 'Discount':
                        type = ProductFilterUI.LIST_VIEW;
                        break;
                      case 'Price':
                        type = ProductFilterUI.SLIDER_VIEW;
                        break;
                    }

                    selectedFilter.add(
                        ProductFilterUI(filter: filters[index], type: type));
                  },
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: filters[index].isFilterApplied
                            ? Colors.white
                            : Colors.grey[200],
                        border: Border(
                          bottom: BorderSide(
                            //                   <--- left side
                            color: Colors.grey,
                            width: 0.2,
                          ),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(filters[index].name),
                      )),
                ),
              ),
            ),
            StreamBuilder<ProductFilterUI>(
                stream: selectedFilter,
                builder: (BuildContext context,
                    AsyncSnapshot<ProductFilterUI> snapshot) {

                  if(snapshot.data!=null) {
                    return Container(
                      width: 3 * MediaQuery
                          .of(context)
                          .size
                          .width / 4 - 50,
                      child: snapshot.data.type == ProductFilterUI.GRID_VIEW
                          ? FilterGridViewContainer(
                        filter: snapshot.data.filter,
                      )
                          : snapshot.data.type == ProductFilterUI.LIST_VIEW
                          ? FilterListViewSearchContainer(
                        filter: snapshot.data.filter,
                      )
                          : FilterSliderContainer(
                        filter: snapshot.data.filter,
                      ),
                    );
                    }else
                      return Container();
                }),
          ],
        ),
      ),
    );
  }
}
