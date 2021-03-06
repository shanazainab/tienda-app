import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tienda/controller/db-controller.dart';
import 'package:tienda/controller/download-controller.dart';
import 'package:tienda/model/product.dart';

class ProductVideoDownloader extends StatefulWidget {
  final Product product;

  ProductVideoDownloader(this.product);

  @override
  _ProductVideoDownloaderState createState() => _ProductVideoDownloaderState();
}

class _ProductVideoDownloaderState extends State<ProductVideoDownloader>
    with WidgetsBindingObserver {
  ReceivePort _port = ReceivePort();
  String _localPath;
  DownloadTaskProgress downloadProgress;

  DownloadController downloadController = new DownloadController();

  bool isStatusClear = false;

  String status;

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
    _prepare();

  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      IsolateNameServer.removePortNameMapping('downloader_send_port');
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      print('.............UI Isolate Callback: $data');

      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      downloadController.updateDownloadTasks(DownloadTaskProgress(
          taskId: data[0],
          productId: widget.product.id,
          status: data[1],
          progress: data[2]));
    });
  }

  ///Product video downloads
  void _requestDownload() async {
    var status = await Permission.storage.status;
    print(">>>>>>>STORAGE PERMISSION STATUS:$status");
    if (status.isUndetermined) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[Permission.storage]);
    }
    String taskId = await FlutterDownloader.enqueue(
        url: widget.product.lastVideo,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
    DBController().insertData(new DownloadTaskProgress(
        productId: widget.product.id,
        taskId: taskId,
        storagePath: _localPath,
        videoName: widget.product.nameEn));
    downloadProgress =
        new DownloadTaskProgress(productId: widget.product.id, taskId: taskId);
  }

  _cancelDownload(String taskId) {
    FlutterDownloader.cancel(taskId: taskId);
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  _prepare() async {
    status =
        await DBController().checkDBForDownloadedProduct(widget.product.id);
    Logger().e("DOWNLOAD STATUS:$status");
    String localPath = await _findLocalPath();
    _localPath = localPath + Platform.pathSeparator + 'Download';
    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    Logger().d("DIRECTORY EXIST : $hasExisted");

    if (!hasExisted) {
      savedDir.create();
    }
    print("DOWNLOAD LOCATION PATH:$_localPath");
    setState(() {});

  }


  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DownloadTaskProgress>>(
        stream: downloadController.downloadStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<DownloadTaskProgress>> snapshot) {
          if (snapshot.data != null && status != null) {
            int progress;
            String taskId;
            for (final task in snapshot.data) {
              if (task.productId == widget.product.id) {
                progress = task.progress;
                taskId = task.taskId;

                if (progress == 100 || progress == -1) {
                  ///TODO: ADD TO DB
                  DBController().updateDB(new DownloadTaskProgress(
                      productId: widget.product.id,
                      taskId: taskId,
                      storagePath: _localPath,
                      videoName: widget.product.nameEn));
                }
              }
            }

            return status == "OFFLINE"
                ? GestureDetector(
                    onTap: () {
                      ///Navigate to all downloads page
                    },
                    child: Card(
                      color: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4, bottom: 4),
                        child: Text(status),
                      ),
                    ))
                : progress != null
                    ? progress != 100 && progress != -1
                        ? GestureDetector(
                            onTap: () {
                              print("Tapped");
                              _cancelDownload(taskId);
                            },
                            child: CircularPercentIndicator(
                              radius: 30.0,
                              lineWidth: 2.0,
                              animateFromLastPercent: true,
                              animation: true,
                              percent: progress / 100,
                              center: Icon(
                                Icons.close,
                                size: 16,
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Colors.pinkAccent,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              print("Tapped empty");
                            },
                            child: CircularPercentIndicator(
                              radius: 30.0,
                              lineWidth: 2.0,
                              animateFromLastPercent: true,
                              animation: true,
                              percent: 1.0,
                              center: Icon(
                                Icons.done,
                                size: 16,
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Colors.pinkAccent,
                            ),
                          )
                    : GestureDetector(
                        onTap: () {
                          print("Tapped");

                          _requestDownload();
                        },
                        child: CircularPercentIndicator(
                          radius: 30.0,
                          lineWidth: 2.0,
                          animateFromLastPercent: true,
                          animation: true,
                          percent: 0,
                          center: Icon(
                            Icons.save_alt,
                            size: 16,
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.pinkAccent,
                        ),
                      );
          } else if (snapshot.data == null && status != null)
            return status == "OFFLINE"
                ? GestureDetector(
                    onTap: () {
                      ///Navigate to all downloads page
                    },
                    child: Card(
                      color: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4, bottom: 4),
                        child: Text(status),
                      ),
                    ))
                : status == "NOT-OFFLINE"
                    ? GestureDetector(
                        onTap: () {
                          print("Tapped");

                          _requestDownload();
                        },
                        child: CircularPercentIndicator(
                          radius: 30.0,
                          lineWidth: 2.0,
                          animateFromLastPercent: true,
                          animation: true,
                          percent: 0,
                          center: Icon(Icons.save_alt, size: 16),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.pinkAccent,
                        ),
                      )
                    : Container();
          else
            return Container();
        });
  }
}
