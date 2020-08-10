import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_playout/player_state.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/view/live-stream/video-playout.dart';
import 'package:tienda/view/products/featured-product-list.dart';
import 'package:video_player/video_player.dart';

class SellerProfileContainer extends StatefulWidget {
  final GlobalKey pageViewGlobalKey;

  final Presenter presenter;

  SellerProfileContainer(this.presenter, this.pageViewGlobalKey);

  @override
  _SellerProfileContainerState createState() => _SellerProfileContainerState();
}

class _SellerProfileContainerState extends State<SellerProfileContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
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
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate("products")
                        .toUpperCase(),
                    style: TextStyle(color: Colors.blue, fontSize: 12),
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
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate("videos")
                        .toUpperCase(),
                    style: TextStyle(color: Colors.blue, fontSize: 12),
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
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate("followers")
                        .toUpperCase(),
                    style: TextStyle(color: Colors.blue, fontSize: 12),
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
            ? FeaturedProductList(
                products: widget.presenter.featuredProducts,
              )
            : Container(),
      ],
    );
  }
}
