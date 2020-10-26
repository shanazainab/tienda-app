import 'package:flutter/material.dart';
import 'package:tienda/model/product.dart';

typedef OnTabSwitch = Function(double position);

class ProductDescriptionTab extends StatelessWidget {
  final Product product;

  final OnTabSwitch onTabSwitch;

  ProductDescriptionTab(this.product, this.onTabSwitch);

  final GlobalKey _keySpec = GlobalKey();
  final GlobalKey _keyOverView = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: TabBar(
                isScrollable: false,
                onTap: (index) {
                  if (index == 1) {
                    final RenderBox renderBoxRed =
                        _keySpec.currentContext.findRenderObject();
                    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
                    onTabSwitch(positionRed.dy);
                  } else {
                    final RenderBox renderBoxRed =
                        _keyOverView.currentContext.findRenderObject();
                    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
                    onTabSwitch(positionRed.dy);
                  }
                },
                indicatorColor: Color(0xff50C0A8),
                labelColor: Color(0xff50C0A8),
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0,
                ),
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0,
                ),
                tabs: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    alignment: Alignment.center,
                    child: Tab(
                      text: 'OVERVIEW',
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Tab(
                        text: 'SPECIFICATION',
                      )),
                ],
              ),
            ),
            Visibility(
                visible: product.specs != null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 12),
                  child: Text("Overview",
                      style: TextStyle(
                        color: Color(0xff555555),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0,
                      )),
                )),
            ListView.builder(
                key: _keyOverView,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: product.features.length,
                padding: const EdgeInsets.all(12.0),
                itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        product.features[index].value,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    )),
            Visibility(
                visible: product.specs != null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 12),
                  child: Text("Specification",
                      style: TextStyle(
                        color: Color(0xff555555),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0,
                      )),
                )),
            ListView.builder(
                key: _keySpec,
                padding: const EdgeInsets.all(12.0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: product.specs.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width / 2 - 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                product.specs[index].key,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width / 2 - 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                product.specs[index].value,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),

          ],
        ),
      ),
    );
  }
}
