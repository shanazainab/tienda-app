import 'package:flutter/material.dart';
import 'package:flutter_playout/player_state.dart';
import 'package:tienda/view/live-stream/video-playout.dart';

class ShopLiveScreen extends StatefulWidget {
  @override
  _ShopLiveScreenState createState() => _ShopLiveScreenState();
}

class _ShopLiveScreenState extends State<ShopLiveScreen> {
  bool _showBackButton = false;

  double _leftPad = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: NotificationListener(
          onNotification: (t) {
            if (t is ScrollEndNotification) {
              print("SCROLL END NOTIFICATION");
              setState(() {
                _showBackButton = true;
                _leftPad = 30.0;
              });
              return true;
            } else if (t is ScrollStartNotification) {
              print("SCROLL UPDATE NOTIFICATION");

              setState(() {
                _showBackButton = false;
                _leftPad = 0.0;
              });
              return true;
            } else
              return false;
          },
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                color: Colors.grey[200],
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4 + 50,
                child: Stack(
                  children: <Widget>[
                    SizedBox(
                      height: 400,
                      child: VideoPlayOut(
                        url:
                            'http://192.168.1.93:1935/test_presenter/myStream/playlist.m3u8',
                        desiredState: PlayerState.PLAYING,
                        showPlayerControls: true,
                      ),
                    ),
                    Visibility(
                      visible: _showBackButton,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 14,
                          child: Center(
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Center(
                                  child: Icon(
                                Icons.arrow_back_ios,
                                size: 16,
                              )),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          AnimatedContainer(
                              duration: Duration(
                                milliseconds: 500,
                              ),
                              padding: EdgeInsets.only(left: _leftPad),
                              child: Text(
                                "FEATURED",
                                style: TextStyle(color: Colors.white),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.access_time,
                                size: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("1 day ago"),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                color: Colors.grey[200],
                                height: 100,
                                width: 90,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: 200,
                              child: Text(
                                'some random string some description item for live stream videos',
                                softWrap: true,
                              ),
                            )
                          ],
                        ),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
