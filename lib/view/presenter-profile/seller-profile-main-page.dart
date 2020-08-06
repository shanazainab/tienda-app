import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/events/follow-events.dart';
import 'package:tienda/bloc/events/presenter-events.dart';
import 'package:tienda/bloc/follow-bloc.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/bloc/states/follow-states.dart';
import 'package:tienda/bloc/states/presenter-states.dart';
import 'package:tienda/localization.dart';

import 'package:tienda/view/presenter-profile/seller-profile-container.dart';
import 'package:tienda/view/presenter-profile/seller-profile-video-list.dart';

class SellerProfilePage extends StatelessWidget {
  final int presenterId;

  SellerProfilePage(this.presenterId);

  final GlobalKey pageViewGlobalKey =
      new GlobalKey(debugLabel: 'seller-page-view');

  final PageController pageViewController =
      PageController(initialPage: 0, keepPage: false);

  FollowBloc followBloc = new FollowBloc();


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
                return Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "${GlobalConfiguration().getString("baseURL")}/${state.presenter.headerProfile}",
                            )),
                      ),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
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
                                    Text(
                                      state.presenter.name,
                                      style: TextStyle(
                                          fontSize: 24, color: Colors.white),
                                    ),
                                  ],
                                ),
                                BlocBuilder<FollowBloc, FollowStates>(
                                    bloc:followBloc,
                                    builder: (context, substate) {
                                      if (substate is ChangeFollowStatusSuccess)
                                        return RaisedButton(
                                          onPressed: () {
                                            followBloc.add(
                                                ChangeFollowStatus(
                                                    state.presenter.id));
                                          },
                                          color: Colors.blue,
                                          child: substate.isFollowing
                                              ? Text("Following")
                                              : Text(
                                                  AppLocalizations.of(context)
                                                      .translate("follow")),
                                        );
                                      return RaisedButton(
                                        onPressed: () {
                                         followBloc.add(
                                              ChangeFollowStatus(
                                                  state.presenter.id));
                                        },
                                        color: Colors.blue,
                                        child: state.presenter.isFollowed
                                            ? Text("Following")
                                            : Text(AppLocalizations.of(context)
                                                .translate("follow")),
                                      );
                                    })
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
                            SellerProfileContainer(
                                state.presenter, pageViewGlobalKey),
                            SellerProfileVideoList(
                                state.presenter, pageViewGlobalKey)
                          ],
                        ),
                      ),
                    )
                  ],
                );
              else
                return Container();
            })));
  }
}
