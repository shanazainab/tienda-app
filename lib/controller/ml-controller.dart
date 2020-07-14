import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class MLController {
  ImageLabeler labeler;

  createImageLabels(File imageFile) async {
    // final File imageFile = await getImageFileFromAssets();
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);

    labeler = FirebaseVision.instance.imageLabeler();
    final List<ImageLabel> labels = await labeler.processImage(visionImage);

    for (ImageLabel label in labels) {
      final String text = label.text;
      final String entityId = label.entityId;
      final double confidence = label.confidence;
      print("IMAGE LABELING RESULT:$text , $entityId, $confidence");
    }
  }

  Future<File> getImageFileFromAssets() async {
    final byteData = await rootBundle.load('assets/images/chair.jpg');
    final file = File('${(await getTemporaryDirectory()).path}/chair.jpg');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
  close() {
    labeler.close();
  }
}
