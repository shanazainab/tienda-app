import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:tienda/view/products/featured-product-list.dart';
import 'package:tienda/view/seller-profile/seller-profile-main-page.dart';
import 'package:video_player/video_player.dart';

class SellerProfileContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
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
                    Text("PRODUCTS")
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
                    Text("VIDEOS")
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
                    Text("FOLLOWERS")
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
              child: Text("Popular Videos",
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
                    'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4'),
                aspectRatio: 3 / 2,
                autoPlay: false,
                looping: true,
                allowFullScreen: true,
              ),
            ),
          ),

          Center(
              child: FlatButton(
                  onPressed: () {
                    PageView pageView = pageViewGlobalKey.currentWidget;
                    pageView.controller.jumpToPage(1);
                  },
                  child: Text(
                    "See all",
                    style: TextStyle(color: Colors.lightBlue),
                  ))),

          FeaturedProductList(),
          Center(
              child: FlatButton(
                  onPressed: () {},
                  child: Text(
                    "See all",
                    style: TextStyle(color: Colors.lightBlue),
                  ))),
        ],
      ),
    );
  }
}
