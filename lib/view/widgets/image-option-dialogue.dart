import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tienda/view/search/take-a-picture-screen.dart';

typedef SelectedImage = Function(File image);

class ImageOptionDialogue extends StatelessWidget {
  final CameraDescription camera;
  final SelectedImage selectedImage;

  ImageOptionDialogue({this.camera, this.selectedImage});

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    selectedImage(File(pickedFile.path));
  }

  Future takeImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    selectedImage(File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
              onPressed: () {
                ///close the modal bottom sheet
                Navigator.of(context).pop();

                if (camera == null) {
                  takeImage();
                } else
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TakePictureScreen(
                              camera: camera,
                            )),
                  );
              },
              child: Text("Take A Photo")),
          FlatButton(
              onPressed: () {
                ///close the modal bottom sheet
                Navigator.of(context).pop();
                getImage();
              },
              child: Text("Choose An Existing Photo"))
        ],
      ),
    );
  }
}
