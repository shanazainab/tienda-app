import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/presenter-events.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/bloc/states/presenter-states.dart';
import 'package:tienda/view/presenter-profile/presenter-profile-contents.dart';


import '../../loading-widget.dart';

class PresenterProfilePage extends StatelessWidget {
  final int presenterId;
  final String presenterName;
  final String profileImageURL;

  PresenterProfilePage(
      {this.presenterId, this.presenterName, this.profileImageURL});

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
            body: BlocBuilder<PresenterBloc, PresenterStates>(
                builder: (context, state) {
              if (state is LoadPresenterDetailsSuccess)
                return PresenterProfileContents(
                    state.presenter, pageViewGlobalKey);
              else
                return spinkit;
            })));
  }
}
