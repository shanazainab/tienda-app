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
              Center(
                child: TabBar(
                  controller: _tabController,
                  labelPadding: EdgeInsets.only(left: 16, right: 16),
                  isScrollable: false,
                  indicatorColor: Colors.grey,
                  labelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                  unselectedLabelColor: Colors.grey,
                  unselectedLabelStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
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
                    padding: EdgeInsets.all(0),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.productSpec.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) => widget
                                  .productSpec[index].key !=
                              "Description"
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.0,bottom: 16.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child:
                                          Text(widget.productSpec[index].key,style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black
                                          ),),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child:
                                          Text(widget.productSpec[index].value,style: TextStyle(
                                              fontSize: 12,
                                            color: Colors.grey
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
                      padding: EdgeInsets.all(0),
                      itemBuilder: (BuildContext context, int index) =>
                          widget.productSpec[index].key == "Description"
                              ? Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(widget.productSpec[index].value,style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.justify,),
                              )
                              : Container()),
                ][_tabIndex],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
