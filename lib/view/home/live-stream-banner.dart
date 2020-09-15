import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import 'package:tienda/model/home-screen-data-response.dart';

class LiveStreamBanner extends StatelessWidget {
  final LiveStream liveStream;

  LiveStreamBanner(this.liveStream);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                "${GlobalConfiguration().getString("imageURL")}/${liveStream.thumbnail}",
              ),
              fit: BoxFit.cover)),
      child: RaisedButton(
        onPressed: () {},
        child: Text("JOIN LIVE"),
      ),
    );
  }
}
