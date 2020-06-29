import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/product-events.dart';
import 'package:tienda/bloc/product-bloc.dart';
import 'package:tienda/bloc/states/product-states.dart';
import 'package:tienda/view/products/featured-product-list.dart';
import 'package:video_player/video_player.dart';

class SellerProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            ProductBloc()..add(FetchProductList()),
        child: Scaffold(
            body: ListView(
              shrinkWrap: true,
          children: <Widget>[
            Container(
              color: Colors.grey[200],
              height: 200,
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
                            Text("John Doe"),
                            Text("Last online Today")
                          ],
                        ),
                        RaisedButton(
                          onPressed: () {},
                          color: Colors.blue,
                          child: Text("Follow"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
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

            FeaturedProductList(),


          ],
        )));
  }
}
