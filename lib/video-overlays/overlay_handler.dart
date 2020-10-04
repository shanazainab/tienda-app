import 'package:flutter/material.dart';
import 'package:tienda/view/widgets/bottom-nav-bar.dart';

class OverlayHandlerProvider with ChangeNotifier {
  OverlayEntry overlayEntry;
  OverlayEntry mainOverlayEntry;

  double _aspectRatio = 1.77;
  bool inPipMode = false;

  enablePip(double aspect) {
    inPipMode = true;
    _aspectRatio = aspect;
    print("$inPipMode enablePip");
    notifyListeners();
  }

  disablePip() {
    inPipMode = false;
    print("$inPipMode disablePip");
    notifyListeners();
  }

  get overlayActive => overlayEntry != null;

  get aspectRatio => _aspectRatio;

  insertOverlay(
      BuildContext context, OverlayEntry overlay, bool isBottomNavBar) {
    if (isBottomNavBar) {
      if (overlayEntry != null) {
        overlayEntry.remove();
      }
      overlayEntry = null;
      inPipMode = false;
      Overlay.of(context, rootOverlay: false).insert(overlay);
      mainOverlayEntry = overlay;
    } else {
      if (overlayEntry != null) {
        overlayEntry.remove();
      }
      overlayEntry = null;
      inPipMode = false;
      Overlay.of(context, rootOverlay: false)
          .insert(overlay, below: mainOverlayEntry);
      overlayEntry = overlay;
    }

    // if(overlayEntry != null) {
    //   overlayEntry.remove();
    // }
    // overlayEntry = null;
    // inPipMode = false;
    //  Overlay.of(context,rootOverlay: false).insert(overlay);
  }

  removeOverlay(BuildContext context) {
    if (overlayEntry != null) {
      overlayEntry.remove();
    }
    overlayEntry = null;
  }
}
