import 'package:flutter/material.dart';

import 'package:tienda/localization.dart';

import 'package:tienda/view/search/search-home-container.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light, // or use Brightness.dark

        elevation: 0,

        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: TextField(
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
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8.0),
            child: Icon(
              Icons.keyboard_voice,
              size: 22,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Icon(
              Icons.camera_alt,
              size: 22,
            ),
          )
        ],
      ),
      body: SearchHomeContainer(),
    );
  }
}
