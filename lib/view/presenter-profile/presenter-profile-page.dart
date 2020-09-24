import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/bloc/events/follow-events.dart';
import 'package:tienda/bloc/events/presenter-events.dart';
import 'package:tienda/bloc/follow-bloc.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/bloc/states/presenter-states.dart';
import 'package:tienda/model/product.dart';
import 'package:tienda/video-overlays/overlay_service.dart';
import 'package:tienda/view/products/product-review-page.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../localization.dart';

class PresenterProfilePage extends StatefulWidget {
  final int presenterId;
  final String presenterName;
  final String profileImageURL;

  PresenterProfilePage(
      {this.presenterId, this.presenterName, this.profileImageURL});

  @override
  _PresenterProfilePageState createState() => _PresenterProfilePageState();
}

class _PresenterProfilePageState extends State<PresenterProfilePage> {
  final GlobalKey pageViewGlobalKey =
      new GlobalKey(debugLabel: 'seller-page-view');

  final stream = new BehaviorSubject<List<Product>>();
  final PageController pageViewController =
      PageController(initialPage: 0, keepPage: false);
  FollowBloc followBloc = new FollowBloc();

  bool following = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            PresenterBloc()..add(LoadPresenterDetails(widget.presenterId)),
        child: BlocListener<PresenterBloc, PresenterStates>(
          listener: (context, state) {
            if (state is LoadPresenterDetailsSuccess) {
              stream.sink.add(state.presenter.featuredProducts);
            }
          },
          child: Scaffold(
              extendBodyBehindAppBar: true,
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height / 2,
                    centerTitle: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        imageUrl:
                            "${GlobalConfiguration().getString("imageURL")}${widget.profileImageURL}",
                        fit: BoxFit.cover,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(widget.presenterName),
                              // Text(
                              //   state.presenter.shortDescription,
                              //   style: TextStyle(
                              //     fontSize: 12,
                              //   ),
                              // ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: ButtonTheme(
                              height: 25,
                              minWidth: 30,
                              child: RaisedButton(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 4, bottom: 4),
                                color: Colors.black,
                                onPressed: () {
                                  setState(() {
                                    following = !following;
                                  });
                                  followBloc.add(
                                      ChangeFollowStatus(widget.presenterId));

                                  FirebaseAnalytics().logEvent(
                                      name: "PROFILE_VIEW",
                                      parameters: {
                                        'presenter_name': widget.presenterName,
                                        'category_name': ''
                                        // widget.
                                      });
                                },
                                child: following
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Following",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 14,
                                          )
                                        ],
                                      )
                                    : Text(
                                        AppLocalizations.of(context)
                                            .translate("follow"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal),
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                      centerTitle: false,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        BlocBuilder<PresenterBloc, PresenterStates>(
                            builder: (context, state) {
                          if (state is LoadPresenterDetailsSuccess) {
                            following = state.presenter.isFollowed;

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
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
                                                fontSize: 30,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate("products")
                                                  .toUpperCase(),
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
                                            state.presenter.videos.toString(),
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate("videos")
                                                  .toUpperCase(),
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
                                                fontSize: 30,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate("followers")
                                                  .toUpperCase(),
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16, top: 16),
                                  child: Text(
                                    state.presenter.bio,
                                    style: TextStyle(color: Colors.grey),
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      state.presenter.popularVideos.isNotEmpty,
                                  child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                          AppLocalizations.of(context)
                                              .translate("popular-videos")
                                              .toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold))),
                                ),

                                ///NOTE: only https video

                                Visibility(
                                  visible:
                                      state.presenter.popularVideos.isNotEmpty,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SizedBox(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Container(
                                          color: Colors.grey,
                                          child: Center(
                                            child:
                                                Icon(Icons.play_circle_outline),
                                          ),
                                        )),
                                  ),
                                ),

                                Visibility(
                                  visible:
                                      state.presenter.popularVideos.isNotEmpty,
                                  child: Center(
                                      child: FlatButton(
                                          onPressed: () {
                                            PageView pageView =
                                                pageViewGlobalKey.currentWidget;
                                            pageView.controller.animateToPage(1,
                                                duration: Duration(seconds: 1),
                                                curve: Curves.easeIn);
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("see-all"),
                                            style: TextStyle(
                                                color: Colors.lightBlue),
                                          ))),
                                ),
                              ],
                            );
                          } else
                            return Container();
                        }),
                      ],
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    BlocBuilder<PresenterBloc, PresenterStates>(
                        builder: (context, state) {
                      if (state is LoadPresenterDetailsSuccess) {
                        return Visibility(
                          visible: state.presenter.featuredProducts.isNotEmpty,
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                  AppLocalizations.of(context)
                                      .translate("featured-products")
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                        );
                      } else
                        return Container();
                    })
                  ])),

                  SliverList(
                    delegate: SliverChildListDelegate([Container(
                        child: StreamBuilder(
                            stream: stream,
                            builder: (context, snapshot) {
                              if (snapshot.data != null)
                                return GridView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(bottom: 40),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,childAspectRatio: 0.9),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        height: 160,
                                        width:
                                        MediaQuery.of(context).size.width / 2,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                OverlayService()
                                                    .addVideoTitleOverlay(
                                                    context,
                                                    ProductReviewPage(snapshot
                                                        .data[index].id),
                                                    false);
                                              },
                                              child: FadeInImage.memoryNetwork(
                                                image:
                                                "${snapshot.data[index].thumbnail}",
                                                height: 160,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    2,
                                                fit: BoxFit.cover,
                                                placeholder: kTransparentImage,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(top: 8.0),
                                              child: Text(
                                                snapshot.data[index].nameEn,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(top: 8.0),
                                              child: Text(
                                                  "AED ${snapshot.data[index].price}"),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              else
                                return Container();
                            })
                    )]),
                  )


                ],
              )

              // BlocBuilder<PresenterBloc, PresenterStates>(
              //     builder: (context, state) {
              //   if (state is LoadPresenterDetailsSuccess) {
              //
              //   } else
              //     return spinkit;
              // })

              ),
        ));
  }
}
