import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/model/product-list-response.dart' as PLR;
import 'package:tienda/model/search-body.dart';
import 'package:tienda/view/filter/filter-grid-view-container.dart';
import 'package:tienda/view/filter/filter-listview-search-container.dart';
import 'package:tienda/view/filter/fliter-slider-container.dart';

class ProductFilter extends StatefulWidget {
  final List<PLR.Filter> availableFilters;
  final String query;
  final SearchBody searchBody;

  ProductFilter(this.availableFilters, this.query, {this.searchBody});

  @override
  _ProductFilterState createState() => _ProductFilterState();
}

class _ProductFilterState extends State<ProductFilter> {
  final selectedFilterUI = BehaviorSubject<PLR.Filter>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedFilterUI.add(widget.availableFilters[0]);
  }

  @override
  Widget build(BuildContext contextA) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        title: Text("Filters"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              handleFilterClear();
            },
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('CLOSE'),
            ),
          ),
          Expanded(
            child: FlatButton(
              onPressed: () {
                handleFilterApply(contextA);
              },
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
                itemCount: widget.availableFilters.length,
                itemBuilder: (BuildContext context, int index) => widget
                        .availableFilters[index].values.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          selectedFilterUI.add(widget.availableFilters[index]);
                        },
                        child: StreamBuilder<PLR.Filter>(
                            stream: selectedFilterUI,
                            builder: (BuildContext context,
                                AsyncSnapshot<PLR.Filter> snapshot) {
                              return Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: snapshot.data != null &&
                                            snapshot.data.filterName ==
                                                widget.availableFilters[index]
                                                    .filterName
                                        ? Colors.white
                                        : Colors.grey[200],
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 0.2,
                                      ),
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(widget.availableFilters[index]
                                            .filterName),
                                        widget.availableFilters[index].chosen !=
                                                    null &&
                                                widget.availableFilters[index]
                                                    .chosen
                                            ? Icon(Icons.check,
                                                size: 16, color: Colors.blue)
                                            : Container()
                                      ],
                                    ),
                                  ));
                            }),
                      )
                    : Container(),
              ),
            ),
            StreamBuilder<PLR.Filter>(
                stream: selectedFilterUI,
                builder:
                    (BuildContext context, AsyncSnapshot<PLR.Filter> snapshot) {
                  if (snapshot.data != null) {
                    return Container(
                      width: 3 * MediaQuery.of(context).size.width / 4 - 50,
                      child: snapshot.data.filterName == "seller" ||
                              snapshot.data.filterName == "colors" ||
                              snapshot.data.filterName == "size"
                          ? FilterGridViewContainer(
                              filter: snapshot.data,
                            )
                          : snapshot.data.filterName == "brands" ||
                                  snapshot.data.filterName == "discounts"
                              ? FilterListViewSearchContainer(
                                  filter: snapshot.data,
                                  isFilterChosen: (isChosen) {
                                    setState(() {});
                                  },
                                )
                              : FilterSliderContainer(
                                  filter: snapshot.data,
                                  isFilterChosen: (isChosen) {
                                    setState(() {});
                                  },
                                ),
                    );
                  } else
                    return Container();
                }),
          ],
        ),
      ),
    );
  }

  void handleFilterClear() {
    for (final filter in widget.availableFilters) {
      filter.chosen = false;
      for (final value in filter.values) {
        value.chosen = false;
        value.chosenMaxPrice = null;
        value.chosenMinPrice = null;
      }
    }

    setState(() {});
  }

  void handleFilterApply(contextA) {
    double minPrice;
    double maxPrice;

    for (final filter in widget.availableFilters) {
      ///price
      if (filter.filterName == "price") {
        if (filter.values[0].chosenMinPrice != null &&
            filter.values[0].chosenMaxPrice != null) {
          minPrice = filter.values[0].chosenMinPrice;
          maxPrice = filter.values[0].chosenMaxPrice;
        } else if (filter.values[0].chosenMinPrice != null &&
            filter.values[0].chosenMaxPrice == null) {
          minPrice = filter.values[0].chosenMinPrice;
          maxPrice = filter.values[0].maxPrice;
        } else if (filter.values[0].chosenMinPrice == null &&
            filter.values[0].chosenMaxPrice != null) {
          minPrice = filter.values[0].minPrice;
          maxPrice = filter.values[0].chosenMaxPrice;
        }
      }

      ///brands
      if (filter.filterName == "brands") {
        for (final value in filter.values) {
          if (value.chosen != null && value.chosen) {
            if (widget.searchBody.brands == null)
              widget.searchBody.brands = new List()..add(value.brandName);
            else
              widget.searchBody.brands.add(value.brandName);
          }
        }
      }
    }

    widget.searchBody.priceGt = minPrice?.toInt();
    widget.searchBody.priceLt = maxPrice?.toInt();

    BlocProvider.of<ProductBloc>(contextA)
      ..add(FetchFilteredProductList(
          query: widget.query, searchBody: widget.searchBody));

    Navigator.pop(contextA);
  }
}
