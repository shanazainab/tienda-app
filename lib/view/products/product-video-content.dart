import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/controller/video-controls.dart';
import 'package:tienda/model/product.dart';
import 'package:video_player/video_player.dart';

class ProductVideoContent extends StatefulWidget {
  final Product product;

  ProductVideoContent(this.product);

  @override
  _ProductVideoContentState createState() => _ProductVideoContentState();
}

class _ProductVideoContentState extends State<ProductVideoContent> {
  VideoPlayerController _controller;
  double _value;
  VideoControls videoControls = new VideoControls();

  double _height = 300;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _value = 0.1;
    _controller = VideoPlayerController.network(widget.product.lastVideo)
      ..initialize().then((_) {
        print("DURATION:${_controller.value.duration.inMinutes}");
        videoControls.updateControls(
            new Controls(isPlaying: true, show: false, showProgress: false));
      })
      ..play();

    _controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Container(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GestureDetector(
                  onTap: () {
                    if (videoControls.controls.value == null) {
                      videoControls.updateControls(
                          new Controls(isPlaying: true, show: true));
                    } else {
                      videoControls.controls.value.show =
                          videoControls.controls.value.show == null
                              ? true
                              : !videoControls.controls.value.show;
                      videoControls
                          .updateControls(videoControls.controls.value);
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: _height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        VideoPlayer(_controller),
                      ],
                    ),
                  )),
              StreamBuilder<Controls>(
                  stream: videoControls.controls,
                  builder:
                      (BuildContext context, AsyncSnapshot<Controls> snapshot) {
                    if (snapshot.data != null && snapshot.data.show)
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black.withOpacity(0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              snapshot.data.isPlaying
                                  ? IconButton(
                                      onPressed: () {
                                        videoControls.controls.value.isPlaying =
                                            false;
                                        videoControls.updateControls(
                                            videoControls.controls.value);
                                        _controller.pause();
                                      },
                                      icon: Icon(
                                        Icons.pause,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        videoControls.controls.value.isPlaying =
                                            true;
                                        videoControls.updateControls(
                                            videoControls.controls.value);
                                        _controller.play();
                                      },
                                      icon: Icon(
                                        Icons.play_arrow,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    ),
                              Container(
                                width: MediaQuery.of(context).size.width - 100,
                                child: VideoProgressIndicator(_controller,
                                    allowScrubbing: true,
                                    padding: EdgeInsets.all(8)),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_height ==
                                      MediaQuery.of(context).size.height - 100)
                                    _height = 300;
                                  else
                                    _height =
                                        MediaQuery.of(context).size.height - 100;
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.fullscreen,
                                  size: 24,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    else
                      return Container();
                  })
            ],
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 16, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 1 / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          appLanguage.appLocal == Locale('en')
                              ? widget.product.nameEn
                              : widget.product.nameAr,
                          softWrap: true,
                          maxLines: 2,
                        ),
                        Text(
                          "80k views",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.heart,
                        size: 14,
                        color: Colors.red,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text("60k"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: FaIcon(
                          FontAwesomeIcons.comment,
                          size: 14,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text("120"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
