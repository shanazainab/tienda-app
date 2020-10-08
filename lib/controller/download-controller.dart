import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class DownloadTaskProgress {
  String taskId;
  int productId;
  int progress;
  String storagePath;
  String videoName;
  DownloadTaskStatus status;

  DownloadTaskProgress(
      {this.taskId,
      this.productId,
      this.progress,
      this.status,
      this.storagePath,
      this.videoName});

  @override
  String toString() {
    return 'DownloadTaskProgress{productId: $productId, progress: $progress}';
  }
}

class DownloadController {
  final downloadStream = new BehaviorSubject<List<DownloadTaskProgress>>();

  DownloadController._privateConstructor();

  static final DownloadController _instance =
      DownloadController._privateConstructor();

  factory DownloadController() {
    return _instance;
  }

  updateDownloadTasks(DownloadTaskProgress downloadTaskProgress) {
    if (downloadStream.value != null) {
      bool found = false;
      Logger().d("DOWNLOAD STREAM: ${downloadStream.value}");
      for (int index = 0; index < downloadStream.value.length; ++index) {
        if (downloadStream.value[index].taskId == downloadTaskProgress.taskId) {
          downloadStream.value[index].status = downloadTaskProgress.status;
          downloadStream.value[index].progress = downloadTaskProgress.progress;
          found = true;
        }
      }

      // for (final downloadTask in downloadStream.value) {
      //
      //   if (downloadTask.productId == downloadTaskProgress.productId) {
      //     downloadTask.status = downloadTaskProgress.status;
      //     downloadTask.progress = downloadTaskProgress.progress;
      //     found = true;
      //   }
      // }

      if (found) {
        Logger().d("DOWNLOAD STREAM FOUND: ${downloadStream.value}");

        downloadStream.sink.add(downloadStream.value);
      } else {
        Logger().d("DOWNLOAD STREAM NOT FOUND: ${downloadStream.value}");

        List<DownloadTaskProgress> list = downloadStream.value;
        list.add(downloadTaskProgress);
        downloadStream.sink.add(list);
      }
    } else {
      downloadStream.sink.add([downloadTaskProgress]);
    }
  }
}
