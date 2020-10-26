import 'package:flutter/material.dart';
import 'package:tienda/view/customer-profile/library/offline-videos.dart';
import 'package:tienda/view/customer-profile/library/watch-history.dart';

class CustomerLibrary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity'),
        automaticallyImplyLeading: true,

      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          physics: ScrollPhysics(),
          children: [
            WatchHistory(),
            OfflineVideos(),
          ],
        ),
      ),
    );
  }
}
