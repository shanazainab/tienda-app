import 'package:flutter/material.dart';
import 'package:tienda/view/watch-history/offline-videos.dart';

class WatchHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity'),
      ),
      body: OfflineVideos(),
    );
  }
}
