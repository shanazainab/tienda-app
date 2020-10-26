import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/video-overlays/constants.dart';
import 'package:tienda/video-overlays/overlay_handler.dart';
import 'package:video_player/video_player.dart';

class LiveStreamVideoPlayer extends StatelessWidget {
  const LiveStreamVideoPlayer({
    Key key,
    @required this.aspectRatio,
    @required VideoPlayerController controller,
  })  : _controller = controller,
        super(key: key);

  final double aspectRatio;
  final VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<OverlayHandlerProvider>(
        builder: (context, overlayProvider, _) {
      return Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                RotatedBox(
                  quarterTurns: !overlayProvider.inFullScreenMode ? 0 : 1,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    width: overlayProvider.inPipMode
                        ? (Constants.VIDEO_TITLE_HEIGHT_PIP * aspectRatio)
                        : overlayProvider.inFullScreenMode
                            ? MediaQuery.of(context).size.height
                            : MediaQuery.of(context).size.width,
                    height: overlayProvider.inPipMode
                        ? Constants.VIDEO_TITLE_HEIGHT_PIP
                        : overlayProvider.inFullScreenMode
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.height * 32 / 100,
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: VideoPlayer(
                        _controller,
                      ),
                    ),
                  ),
                ),
                if (!overlayProvider.inPipMode)
                  FutureBuilder(
                    future: Future.delayed(Duration(seconds: 1)),
                    builder: (c, s) => Align(
                      alignment: Alignment.topRight,
                      child: RotatedBox(
                        quarterTurns: !overlayProvider.inFullScreenMode ? 0 : 1,
                        child: Card(
                          margin: EdgeInsets.only(top: 17, right: 11),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(48)),
                          color: !overlayProvider.inFullScreenMode
                              ? Color(0xFFff2e63)
                              : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 4, bottom: 4, left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor:
                                      !overlayProvider.inFullScreenMode
                                          ? Colors.white
                                          : Color(0xFFff2e63),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate("live")
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: !overlayProvider.inFullScreenMode
                                        ? Colors.white
                                        : Color(0xFFff2e63),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (!overlayProvider.inPipMode &&
                    !overlayProvider.inFullScreenMode)
                  Positioned(
                      bottom: 8,
                      right: 8,
                      child: IconButton(
                        onPressed: () {
                          !overlayProvider.inFullScreenMode
                              ? Provider.of<OverlayHandlerProvider>(context,
                                      listen: false)
                                  .enableFullScreen(aspectRatio)
                              : Provider.of<OverlayHandlerProvider>(context,
                                      listen: false)
                                  .disableFullScreen();
                        },
                        icon: Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                        ),
                      )),
                if (!overlayProvider.inPipMode &&
                    overlayProvider.inFullScreenMode)
                  Positioned(
                      bottom: 8,
                      left: 8,
                      child: IconButton(
                        onPressed: () {
                          Provider.of<OverlayHandlerProvider>(context,
                                  listen: false)
                              .disableFullScreen();
                        },
                        icon: Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                        ),
                      ))
              ],
            ),
          ),
          if (overlayProvider.inPipMode)
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  Provider.of<OverlayHandlerProvider>(context, listen: false)
                      .disablePip();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "LIVE",
                  ),
                ),
              ),
            ),
          if (overlayProvider.inPipMode)
            IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              },
            ),
          if (overlayProvider.inPipMode)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Provider.of<OverlayHandlerProvider>(context, listen: false)
                    .removeOverlay(context);
              },
            )
        ],
      );
    });
  }
}
