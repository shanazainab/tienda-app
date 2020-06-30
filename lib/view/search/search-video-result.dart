import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SearchVideoResult extends StatefulWidget {
  @override
  _SearchVideoResultState createState() => _SearchVideoResultState();
}

class _SearchVideoResultState extends State<SearchVideoResult> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) => Container(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    child: Chewie(
                      controller: ChewieController(
                          videoPlayerController: VideoPlayerController.network(
                              'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4'),
                          autoPlay: false,
                          autoInitialize: true,
                          aspectRatio: 16 / 9,
                          showControls: false,
                          allowFullScreen: true,
                          overlay: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.play_circle_outline,
                                      size: 36, color: Colors.white),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "Product Name",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          "Description",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
              )),
    );
  }
}
