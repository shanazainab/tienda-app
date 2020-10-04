import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/video-overlays/videos_title_overlay_widget.dart';

import 'overlay_handler.dart';

class OverlayService {
  addVideoTitleOverlay(
      BuildContext context, Widget widget, bool isLiveStream, isBottomNavBar) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => VideoTitleOverlayWidget(
        onClear: () {
          Provider.of<OverlayHandlerProvider>(context, listen: false)
              .removeOverlay(context);
        },
        widget: widget,
        isLiveStream: isLiveStream,
      ),
    );

    Provider.of<OverlayHandlerProvider>(context, listen: false)
        .insertOverlay(context, overlayEntry, isBottomNavBar);
  }

  addBottomNavigationBar(
      BuildContext context, Widget widget, bool isLiveStream, isBottomNavBar) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => widget,
    );

    Provider.of<OverlayHandlerProvider>(context, listen: false)
        .insertOverlay(context, overlayEntry, isBottomNavBar);
  }
}
