import 'package:flutter/material.dart';
import 'package:tienda/controller/db-controller.dart';
import 'package:tienda/controller/download-controller.dart';
import 'package:tienda/view/customer-profile/library/video-playout-dialogue.dart';
import 'package:tienda/view/widgets/loading-widget.dart';

class OfflineVideos extends StatefulWidget {
  @override
  _OfflineVideosState createState() => _OfflineVideosState();
}

class _OfflineVideosState extends State<OfflineVideos> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DBController().getAllDownloadedData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    DBController().dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Downloads",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          SizedBox(
            height: 16,
          ),
          StreamBuilder<List<DownloadTaskProgress>>(
              stream: DBController().offlineVideos,
              builder: (BuildContext context,
                  AsyncSnapshot<List<DownloadTaskProgress>> snapshot) {
                if (snapshot.data != null && snapshot.data.isNotEmpty)
                  return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) =>
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            50,
                                    color: Colors.grey[100],
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return VideoPlayOutDialogue(
                                                    snapshot.data[index]
                                                        .storagePath);
                                              });
                                        },
                                        icon: Icon(Icons.play_arrow),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                              2 +
                                          30,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          snapshot.data[index].videoName,
                                          softWrap: true,
                                        ),
                                      ))
                                ],
                              ),
                            )),
                  );
                else if (snapshot.data != null && snapshot.data.isEmpty)
                  return Container(
                    child: Center(
                      child: Text("NO OFFLINE VIDEOS"),
                    ),
                  );
                else
                  return Container(
                    child: spinKit,
                  );
              })
        ],
      ),
    );
  }
}
