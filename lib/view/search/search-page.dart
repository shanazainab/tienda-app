import 'dart:io';

import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:tienda/controller/ml-controller.dart';

import 'package:tienda/localization.dart';
import 'package:tienda/view/widgets/image-option-dialogue.dart';

import 'package:tienda/view/search/search-home-container.dart';
import 'package:tienda/view/search/voice-search.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  CameraDescription firstCamera;
  FocusNode searchFocus = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeCamera();
  }

  initializeCamera() async {
    final cameras = await availableCameras();
    firstCamera = cameras.first;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: TextField(
            focusNode: searchFocus,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                filled: true,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 16,
                ),
                prefixIconConstraints: BoxConstraints(
                  minHeight: 32,
                  minWidth: 32,
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[200])),
                isDense: true,
                fillColor: Colors.grey[200],
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[200])),
                focusColor: Colors.grey[200],
                hintText: AppLocalizations.of(context)
                    .translate("search-for-brands-and-products"),
                hintStyle: TextStyle(fontSize: 12),
                border: InputBorder.none),
          ),
        ),
        actions: <Widget>[
          IconButton(
            constraints: BoxConstraints.tight(Size.square(40)),
            padding: EdgeInsets.all(0),
            visualDensity: VisualDensity.compact,
            onPressed: () {
              searchFocus.unfocus();
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext bc) {
                    return VoiceSearch();
                  });
            },
            icon: Icon(
              Icons.keyboard_voice,
              size: 22,
            ),
          ),
          IconButton(
            constraints: BoxConstraints.tight(Size.square(40)),
            padding: EdgeInsets.all(0),
            visualDensity: VisualDensity.compact,
            onPressed: () {
              // MLController().createImageLabels();
              searchFocus.unfocus();
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext bc) {
                    return ImageOptionDialogue(
                      camera: null,
                      selectedImage: (image) {
                        handleImageSearchQuery(image);
                      },
                    );
                  });
            },
            icon: Icon(
              Icons.camera_alt,
              size: 22,
            ),
          ),
          SizedBox(
            width: 8,
          )
        ],
      ),
      body: SearchHomeContainer(
        onScroll: (status) {
          print("CALLBACK RECEIVED");

          if (status == "START") searchFocus.unfocus();
        },
      ),
    );
  }

  void handleImageSearchQuery(File image) {
    new MLController().createImageLabels(image);
  }
}
