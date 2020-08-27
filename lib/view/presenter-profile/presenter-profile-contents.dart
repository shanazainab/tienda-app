import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/events/follow-events.dart';
import 'package:tienda/bloc/follow-bloc.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/view/presenter-profile/featured-product-grid-view.dart';

class PresenterProfileContents extends StatefulWidget {
  final GlobalKey pageViewGlobalKey;

  final Presenter presenter;

  PresenterProfileContents(this.presenter, this.pageViewGlobalKey);

  @override
  _PresenterProfileContentsState createState() =>
      _PresenterProfileContentsState();
}

class _PresenterProfileContentsState extends State<PresenterProfileContents> {
  FollowBloc followBloc = new FollowBloc();

  bool following = false;

  @override
  void initState() {
    super.initState();
    following = widget.presenter.isFollowed;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  "${GlobalConfiguration().getString("imageURL")}${widget.presenter.profilePicture}",
                )),
          ),
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.presenter.name,
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ],
                    ),

                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          following = !following;
                        });
                        followBloc.add(ChangeFollowStatus(widget.presenter.id));
                      },
                      child: following
                          ? Row(
                              children: [
                                Text(
                                  "Following",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                )
                              ],
                            )
                          : Text(
                              AppLocalizations.of(context).translate("follow"),
                              style: TextStyle(color: Colors.white),
                            ),
                    )

//                    BlocBuilder<FollowBloc, FollowStates>(
//                        bloc: followBloc,
//                        builder: (context, substate) {
//                          if (substate is ChangeFollowStatusSuccess)
//                            return RaisedButton(
//                              onPressed: () {
//                                followBloc.add(
//                                    ChangeFollowStatus(widget.presenter.id));
//                              },
//                              child: substate.isFollowing
//                                  ? Row(
//                                      children: [
//                                        Text(
//                                          "Following",
//                                          style: TextStyle(color: Colors.white),
//                                        ),
//                                        Icon(
//                                          Icons.check,
//                                          color: Colors.white,
//                                          size: 14,
//                                        )
//                                      ],
//                                    )
//                                  : Text(
//                                      AppLocalizations.of(context)
//                                          .translate("follow"),
//                                      style: TextStyle(color: Colors.white),
//                                    ),
//                            );
//                          return RaisedButton(
//                            onPressed: () {
//                              followBloc
//                                  .add(ChangeFollowStatus(widget.presenter.id));
//                            },
//                            child: widget.presenter.isFollowed
//                                ? Row(
//                                    children: [
//                                      Text(
//                                        "Following",
//                                        style: TextStyle(color: Colors.white),
//                                      ),
//                                      Icon(
//                                        Icons.check,
//                                        color: Colors.white,
//                                        size: 14,
//                                      )
//                                    ],
//                                  )
//                                : Text(
//                                    AppLocalizations.of(context)
//                                        .translate("follow"),
//                                    style: TextStyle(color: Colors.white),
//                                  ),
//                          );
//                        })
                  ],
                ),
              )
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Spacer(
                flex: 2,
              ),
              Column(
                children: <Widget>[
                  Text(
                    widget.presenter.products.toString(),
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
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
                    widget.presenter.videos.toString(),
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
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
                    widget.presenter.followers.toString(),
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
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
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.presenter.bio,
            style: TextStyle(color: Colors.grey),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
                AppLocalizations.of(context).translate("popular-videos"),
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))),

        ///NOTE: only https video
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.grey,
                child: Center(
                  child: Icon(Icons.play_circle_outline),
                ),
              )),
        ),
//
//        VideoPlayout(
//          url: 'http://192.168.1.93:1935/test_presenter/myStream/playlist.m3u8',
//          desiredState: PlayerState.PLAYING,
//          showPlayerControls: true,
//        ),

//        Padding(
//            padding: const EdgeInsets.all(16.0),
//            child: AspectRatio(
//              aspectRatio: controller.value.aspectRatio,
//              child: VideoPlayer(controller),
//            )),

        Center(
            child: FlatButton(
                onPressed: () {
                  PageView pageView = widget.pageViewGlobalKey.currentWidget;
                  pageView.controller.animateToPage(1,
                      duration: Duration(seconds: 1), curve: Curves.easeIn);
                },
                child: Text(
                  AppLocalizations.of(context).translate("see-all"),
                  style: TextStyle(color: Colors.lightBlue),
                ))),

        widget.presenter.featuredProducts.isNotEmpty
            ? FeaturedProductGridView(
                products: widget.presenter.featuredProducts,
              )
            : Container(),
      ],
    );
  }
}
