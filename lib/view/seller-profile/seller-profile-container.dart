import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/products/featured-product-list.dart';
import 'package:tienda/view/seller-profile/seller-profile-main-page.dart';
import 'package:video_player/video_player.dart';

class SellerProfileContainer extends StatefulWidget {
  final GlobalKey pageViewGlobalKey;

  SellerProfileContainer(this.pageViewGlobalKey);

  @override
  _SellerProfileContainerState createState() => _SellerProfileContainerState();
}

class _SellerProfileContainerState extends State<SellerProfileContainer> {


  @override
  void initState() {
    // TODO: implement initState

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
                    '200',
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
                    '140',
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
                    '24k',
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
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
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
          child: Chewie(
            controller: ChewieController(
              videoPlayerController: VideoPlayerController.network(
                  'http://192.168.1.83:1935/test_presenter/myStream/playlist.m3u8',
                formatHint: VideoFormat.hls
             ),
              aspectRatio: 3 / 2,
              autoPlay: true,
              isLive: true,
              looping: true,
              autoInitialize: true,
              allowFullScreen: true,
            ),
          ),
        ),

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

        FeaturedProductList(),
        Center(
            child: FlatButton(
                onPressed: () {},
                child: Text(
                  AppLocalizations.of(context).translate("see-all"),
                  style: TextStyle(color: Colors.lightBlue),
                ))),
      ],
    );
  }
}
