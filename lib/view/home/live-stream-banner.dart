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
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                "${GlobalConfiguration().getString("imageURL")}/${liveStream.thumbnail}",
              ),
              fit: BoxFit.cover)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:80.0),
                child: Column(
                  children: [
                    Text(
                      "STREAMING TIME",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Text(
                      DateFormat('hh:mm:ss').format(liveStream.liveTime),
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 4,
                                      backgroundColor: Colors.black,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        liveStream.isLive ? "LIVE" : "UPCOMING",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Text(
                            liveStream.presenterName,
                            style: TextStyle(fontSize: 36, color: Colors.white),
                          )
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "${GlobalConfiguration().getString("imageURL")}/${liveStream.presenterProfilePicture}",
                                  ),
                                  fit: BoxFit.cover)),
                          height: 90,
                          width: 60,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
