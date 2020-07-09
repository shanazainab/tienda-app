import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/localization.dart';

import 'package:tienda/view/seller-profile/seller-profile-container.dart';
import 'package:tienda/view/seller-profile/seller-profile-video-list.dart';

class SellerProfilePage extends StatelessWidget {
  final GlobalKey pageViewGlobalKey =
      new GlobalKey(debugLabel: 'seller-page-view');

  final PageController pageViewController =
      PageController(initialPage: 0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            ProductBloc()..add(FetchProductList()),
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              brightness: Brightness.light,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Column(
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
                                Text("${AppLocalizations.of(context).translate("last-online")} ${AppLocalizations.of(context).translate("today")}")

                              ],
                            ),
                            RaisedButton(
                              onPressed: () {},
                              color: Colors.blue,
                              child: Text(AppLocalizations.of(context).translate("follow")),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: PageView(
                      key: pageViewGlobalKey,
                      controller: pageViewController,
                      children: <Widget>[
                        SellerProfileContainer(pageViewGlobalKey),
                        SellerProfileVideoList(pageViewGlobalKey)
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}
