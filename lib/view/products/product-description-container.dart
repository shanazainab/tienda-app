import 'package:flutter/material.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/product.dart';

class ProductDescriptionContainer extends StatefulWidget {
  final List<Spec> productSpec;

  ProductDescriptionContainer(this.productSpec);

  @override
  _ProductDescriptionContainerState createState() =>
      _ProductDescriptionContainerState();
}

class _ProductDescriptionContainerState
    extends State<ProductDescriptionContainer>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _tabIndex = 0;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text( AppLocalizations.of(context).translate('production-description')),
              Center(
                child: TabBar(
                  controller: _tabController,
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
                        text:  AppLocalizations.of(context).translate('specification'),
                      ),
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Tab(
                          text: AppLocalizations.of(context).translate('description'),
                        )),
                  ],
                ),
              ),
              Center(
                child: [
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.productSpec.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) => widget
                                  .productSpec[index].key !=
                              "Description"
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    color: Colors.grey[200],
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    height: 20,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child:
                                          Text(widget.productSpec[index].key,style: TextStyle(
                                            fontSize: 12
                                          ),),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    color: Colors.blueGrey[200],
                                    height: 20,
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child:
                                          Text(widget.productSpec[index].value,style: TextStyle(
                                              fontSize: 12
                                          ),),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                      )),
                  ListView.builder(
                    shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.productSpec.length,
                      itemBuilder: (BuildContext context, int index) =>
                          widget.productSpec[index].key == "Description"
                              ? Text(widget.productSpec[index].value,style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.justify,)
                              : Text("")),
                ][_tabIndex],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
