import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tienda/view/products/featured-product-list.dart';
import 'package:video_player/video_player.dart';

class SellerProductVideoPage extends StatefulWidget {
  @override
  _SellerProductVideoPageState createState() => _SellerProductVideoPageState();
}

class _SellerProductVideoPageState extends State<SellerProductVideoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Chewie(
            controller: ChewieController(
              videoPlayerController: VideoPlayerController.network(
                  'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4'),
              aspectRatio: 3 / 2,
              autoPlay: false,
              looping: true,
              allowFullScreen: true,
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text("Video Title"), Text("80k views")],
                  ),
                  Row(
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.heart,
                        size: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text("60k"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: FaIcon(
                          FontAwesomeIcons.comment,
                          size: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text("120"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: FaIcon(
                          FontAwesomeIcons.shareAlt,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("John Doe"),
                            Text("20k Followers")
                          ],
                        ),
                      )
                    ],
                  ),
                  Icon(Icons.more_vert)
                ],
              ),
            ),
          ),
          FeaturedProductList(),
          Container(
            child: Column(
              children: <Widget>[
                Text("Similar",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
                ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 90,
                                height: 80,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text("Seller"),
                                  Text("Product"),
                                  Text(
                                    "2M views",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),

        ],
      ),
    );
  }
}
