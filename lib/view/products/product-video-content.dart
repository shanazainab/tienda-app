import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/model/product.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';

class ProductVideoContent extends StatefulWidget {
  final Product product;

  ProductVideoContent(this.product);

  @override
  _ProductVideoContentState createState() => _ProductVideoContentState();
}

class _ProductVideoContentState extends State<ProductVideoContent> {
  VideoPlayerController _controller;

  ChewieController chewieController;

  @override
  void dispose() {
    // TODO: implement dispose
    chewieController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.product.lastVideo);

    chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 3 / 2,
      autoInitialize: true,
      allowFullScreen: true,
      allowMuting: true,
      autoPlay: true,
      looping: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Container(
      child: Column(
        children: [
          Chewie(
            controller: chewieController,
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
