import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/presenter-events.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/bloc/states/presenter-states.dart';

import 'package:tienda/view/presenter-profile/presenter-profile-contents.dart';
import 'package:tienda/view/presenter-profile/presenter-profile-video-list.dart';

class PresenterProfilePage extends StatelessWidget {
  final int presenterId;

  PresenterProfilePage(this.presenterId);

  final GlobalKey pageViewGlobalKey =
      new GlobalKey(debugLabel: 'seller-page-view');

  final PageController pageViewController =
      PageController(initialPage: 0, keepPage: false);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            PresenterBloc()..add(LoadPresenterDetails(presenterId)),
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              brightness: Brightness.light,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: BlocBuilder<PresenterBloc, PresenterStates>(
                builder: (context, state) {
              if (state is LoadPresenterDetailsSuccess)
                return  Container(
                  child: PageView(
                    key: pageViewGlobalKey,
                    controller: pageViewController,
                    children: <Widget>[
                      PresenterProfileContents(
                          state.presenter, pageViewGlobalKey),
                      SellerProfileVideoList(
                          state.presenter, pageViewGlobalKey)
                    ],
                  ),
                );
              else
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Container(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                );
            })));
  }
}
