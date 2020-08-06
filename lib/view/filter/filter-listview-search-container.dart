import 'package:flutter/material.dart';
import 'package:tienda/model/product-list-response.dart';

typedef void IsFilterChosen(bool isChosen);

class FilterListViewSearchContainer extends StatefulWidget {
  final Filter filter;

  final IsFilterChosen isFilterChosen;
  FilterListViewSearchContainer({this.filter,this.isFilterChosen});

  @override
  _FilterListViewSearchContainerState createState() =>
      _FilterListViewSearchContainerState();
}

class _FilterListViewSearchContainerState
    extends State<FilterListViewSearchContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
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
                  hintStyle: TextStyle(fontSize: 12),
                  border: InputBorder.none),
            ),
          ),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (_, index) => Divider(
              indent: 16,
              endIndent: 16,
              height: 0,
            ),
            shrinkWrap: true,
            itemBuilder: (_, index) => ListTile(
                onTap: () {
                  if (widget.filter.values[index].chosen == null) {
                    widget.filter.values[index].chosen = true;
                  }
                  else {
                    widget.filter.values[index].chosen =
                    !widget.filter.values[index].chosen;

                  }
                  bool isChosen = false;
                  for (final value in widget.filter.values) {
                    if (value.chosen != null && value.chosen) isChosen = true;
                  }
                  if (isChosen)
                    widget.filter.chosen = true;
                  else
                    widget.filter.chosen = false;

                  widget.isFilterChosen(isChosen);
                  setState(() {});
                },
                contentPadding:
                    EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.check,
                      size: 16,
                      color:  widget.filter.chosen!=null && widget.filter.chosen && widget.filter.values[index].chosen != null &&
                              widget.filter.values[index].chosen
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ],
                ),
                trailing: Text(
                  widget.filter.filterName == "brands"
                      ? widget.filter.values[index].brandCount.toString()
                      : widget.filter.values[index].count.toString(),
                  style: TextStyle(fontSize: 12),
                ),
                title: Text(
                  widget.filter.filterName == "brands"
                      ? widget.filter.values[index].brandName
                      : "${widget.filter.values[index].discount}% OFF",
                  style: TextStyle(fontSize: 12),
                )),
            itemCount: widget.filter.values.length,
          ),
        ],
      ),
    );
  }
}
