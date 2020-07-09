import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';

class ReturnsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(44.0), // here the desired height

          child: CustomAppBar(
            title: AppLocalizations.of(context).translate("returns"),
            showWishList: false,
            showSearch: false,
            showCart: false,
            showLogo: false,
          )),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: "https://picsum.photos/250?image=9",
                            width: 110,
                            height: 130,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Color(0xfff2f2e4),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text("Brand name"),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text("Description"),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('Qty: 1'),
                                    Text(" | "),
                                    Text('Size: 39')
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text("AED 500"),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
