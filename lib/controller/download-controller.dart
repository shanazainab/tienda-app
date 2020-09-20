import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:rxdart/rxdart.dart';

class DownloadTaskProgress {
  String taskId;
  int productId;
  int progress;
  int storagePath;
  String videoName;
  DownloadTaskStatus status;

  DownloadTaskProgress(
      {this.taskId, this.productId, this.progress, this.status,this.storagePath,this.videoName});


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
      for (final downloadTask in downloadStream.value) {
        if (downloadTask.productId == downloadTaskProgress.productId) {
          downloadTask.status = downloadTaskProgress.status;
          downloadTask.progress = downloadTaskProgress.progress;
          found = true;
        }
      }
      if (found)
        downloadStream.sink.add(downloadStream.value);
      else {
        List<DownloadTaskProgress> list = downloadStream.value;
        list.add(downloadTaskProgress);
        downloadStream.sink.add(list);
      }
    } else {
      downloadStream.sink.add([downloadTaskProgress]);
    }
  }
}
