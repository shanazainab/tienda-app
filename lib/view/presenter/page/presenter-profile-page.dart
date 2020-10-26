import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:share/share.dart';
import 'package:tienda/bloc/events/follow-events.dart';
import 'package:tienda/bloc/events/presenter-events.dart';
import 'package:tienda/bloc/follow-bloc.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/bloc/states/follow-states.dart';
import 'package:tienda/bloc/states/presenter-states.dart';
import 'package:tienda/view/chat/presenter-direct-message.dart';
import 'package:tienda/view/presenter/widget/presenter-bio-tab.dart';
import 'package:tienda/view/presenter/widget/presenter-products-tab.dart';
import 'package:tienda/view/presenter/widget/presenter-video-tab.dart';

import '../../../localization.dart';

class PresenterProfilePage extends StatefulWidget {
  final int presenterId;
  final String profileImageURL;

  PresenterProfilePage({this.presenterId, this.profileImageURL});

  @override
  _PresenterProfilePageState createState() => _PresenterProfilePageState();
}

class _PresenterProfilePageState extends State<PresenterProfilePage>
    with SingleTickerProviderStateMixin {
  FollowBloc followBloc = new FollowBloc();

  TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            PresenterBloc()..add(LoadPresenterDetails(widget.presenterId)),
        child: Scaffold(
            extendBodyBehindAppBar: true,
            body: Container(
              color: Colors.white,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height / 2,
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(3))),
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          sharePresenterProfile();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 42,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            child: SvgPicture.asset(
                              "assets/svg/shares.svg",
                              width: 20,
                              height: 21,

                            ),
                          ),
                        ),
                      )
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, Colors.transparent],
                          ).createShader(rect);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                "${GlobalConfiguration().getString("imageURL")}${widget.profileImageURL}",
                              ),
                            ),
                          ),
                          child: Container(),
                        ),
                      ),
                      title: BlocBuilder<PresenterBloc, PresenterStates>(
                          builder: (context, state) {
                        if (state is LoadPresenterDetailsSuccess) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.presenter.name,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                state.presenter.country == null?"":state.presenter.country.nameEnglish,
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF1A1824)),
                              ),
                            ],
                          );
                        } else
                          return Container();
                      }),
                      centerTitle: true,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        BlocBuilder<PresenterBloc, PresenterStates>(
                            builder: (context, state) {
                          if (state is LoadPresenterDetailsSuccess) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ButtonTheme(
                                            height: 42,
                                            child: BlocBuilder<FollowBloc,
                                                    FollowStates>(
                                                cubit: followBloc,
                                                builder:
                                                    (context, followState) {
                                                  if (followState
                                                      is ChangeFollowStatusSuccess) {
                                                    return RaisedButton(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          3))),
                                                      padding: EdgeInsets.only(
                                                          left: 8,
                                                          right: 8,
                                                          top: 4,
                                                          bottom: 4),
                                                      color: Color(0xFF50C0A8),
                                                      onPressed: () {
                                                        followBloc.add(
                                                            ChangeFollowStatus(
                                                                widget
                                                                    .presenterId));
                                                      },
                                                      child: followState
                                                              .isFollowing
                                                          ? Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                  "Following",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 14,
                                                                )
                                                              ],
                                                            )
                                                          : Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .translate(
                                                                      "follow"),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                    );
                                                  } else
                                                    return RaisedButton(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          3))),
                                                      padding: EdgeInsets.only(
                                                          left: 8,
                                                          right: 8,
                                                          top: 4,
                                                          bottom: 4),
                                                      color: Color(0xFF50C0A8),
                                                      onPressed: () {
                                                        followBloc.add(
                                                            ChangeFollowStatus(
                                                                widget
                                                                    .presenterId));
                                                      },
                                                      child: state.presenter
                                                              .isFollowed
                                                          ? Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                  "Following",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 14,
                                                                )
                                                              ],
                                                            )
                                                          : Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .translate(
                                                                      "follow"),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                    );
                                                })),
                                      ),
                                      SizedBox(
                                        width: 11,
                                      ),
                                      ButtonTheme(
                                        height: 42,
                                        child: OutlineButton(
                                            padding: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 4,
                                                bottom: 4),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PresenterDirectMessage(
                                                            state.presenter)),
                                              );
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/svg/chat.svg",
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    "Chat",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 32.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Spacer(
                                        flex: 2,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            state.presenter.products.toString(),
                                            style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              "Products",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          )
                                        ],
                                      ),
                                      Spacer(
                                        flex: 1,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            state.presenter.videos.length
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              "Videos",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          )
                                        ],
                                      ),
                                      Spacer(
                                        flex: 1,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            state.presenter.followers
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              "Followers",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          )
                                        ],
                                      ),
                                      Spacer(
                                        flex: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                DefaultTabController(
                                  length: 2,
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Center(
                                          child: TabBar(
                                            controller: _tabController,
                                            labelPadding: EdgeInsets.only(
                                                left: 16, right: 16),
                                            isScrollable: false,
                                            indicatorColor: Color(0xff50C0A8),
                                            labelColor: Color(0xff50C0A8),
                                            labelStyle: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            unselectedLabelColor:
                                                Color.fromRGBO(85, 85, 85, 0.7),
                                            unselectedLabelStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    85, 85, 85, 0.7),
                                                fontWeight: FontWeight.bold),
                                            tabs: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                alignment: Alignment.center,
                                                child: Tab(
                                                  text: 'About',
                                                ),
                                              ),
                                              Container(
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  child: Tab(
                                                    text: 'Videos',
                                                  )),
                                              Container(
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  child: Tab(
                                                    text: 'Products',
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: [
                                            PresenterBioTab(
                                                presenter: state.presenter,
                                                onSwitchTabEvent: (value) {
                                                  setState(() {
                                                    _tabIndex = value;
                                                    _tabController.index =
                                                        value;
                                                  });
                                                }),
                                            PresenterVideoTab(state.presenter),
                                            PresenterProductsTab(
                                                state.presenter)
                                          ][_tabIndex],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else
                            return Container();
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  Future<void> sharePresenterProfile() async {
    ///create dynamic link for referral
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://l.tienda.ae/l',
      link: Uri.parse('https://tienda.ae/prsenter/${widget.presenterId}'),
      androidParameters: AndroidParameters(
        packageName: 'com.tienda.liveshop',
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short),
      iosParameters: IosParameters(
        bundleId: 'com.beuniquegroup.tienda',
      ),
    );

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    final RenderBox box = context.findRenderObject();
    Share.share("$shortUrl",
        subject: "Check out this presenter in Tienda !!",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
