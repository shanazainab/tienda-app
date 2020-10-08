import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayOutDialogue extends StatefulWidget {
  final String videoFilePath;

  VideoPlayOutDialogue(this.videoFilePath);

  @override
  _VideoPlayOutDialogueState createState() => _VideoPlayOutDialogueState();
}

class _VideoPlayOutDialogueState extends State<VideoPlayOutDialogue> {
  VideoPlayerController _controller;
  ChewieController chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.file(
        File(widget.videoFilePath + '/sample_review.mp4'));
    chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      autoInitialize: true,
      showControls: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width - 32,
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Chewie(
              controller: chewieController,
            )),
      ),
    );
  }
}
