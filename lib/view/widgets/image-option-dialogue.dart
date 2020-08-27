import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef SelectedImage = Function(File image);

class ImageOptionDialogue extends StatelessWidget {
  final SelectedImage selectedImage;

  ImageOptionDialogue({this.selectedImage});

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    selectedImage(File(pickedFile.path));
  }

  Future takeImage() async {
    print("CAMERA IMAGE");
    final pickedFile = await picker
        .getImage(source: ImageSource.camera);

    selectedImage(File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
              onPressed: () {
                ///close the modal bottom sheet
                Navigator.of(context).pop();
                takeImage();
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
