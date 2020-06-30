import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/product-bloc.dart';

import 'package:tienda/view/seller-profile/seller-profile-container.dart';
import 'package:tienda/view/seller-profile/seller-profile-video-list.dart';

GlobalKey pageViewGlobalKey = new GlobalKey(debugLabel: 'seller-page-view');

class SellerProfilePage extends StatelessWidget {
  final PageController pageViewController =
      PageController(initialPage: 0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            ProductBloc()..add(FetchProductList()),
        child: Scaffold(
            body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              color: Colors.grey[200],
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("John Doe"),
                            Text("Last online Today")
                          ],
                        ),
                        RaisedButton(
                          onPressed: () {},
                          color: Colors.blue,
                          child: Text("Follow"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 500,
              child: PageView(
                key: pageViewGlobalKey,
                controller: pageViewController,
                children: <Widget>[
                  SellerProfileContainer(),
                  SellerProfileVideoList()
                ],
              ),
            )
          ],
        )));
  }
}
