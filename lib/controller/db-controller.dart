import 'dart:developer';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tienda/controller/download-controller.dart';

class DBController {
  Database database;

  DBController._privateConstructor();

  static final DBController _instance = DBController._privateConstructor();

  factory DBController() {
    return _instance;
  }
  final offlineVideos = new BehaviorSubject<List<DownloadTaskProgress>>();

  String get path => 'tiendaDB.db';

  initializeDB() async {
    Logger().e("Initializing DB");
    database = await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
      Logger().e("OPEN DB IS SUCCESS: ${db.path}");
      await db.execute(
          'CREATE TABLE DownloadVideo (productId INTEGER PRIMARY KEY, taskId TEXT,path TEXT, name TEXT,status TEXT)');
    });
  }

  insertData(DownloadTaskProgress downloadTaskProgress) {
    database.rawInsert(
        'INSERT INTO DownloadVideo(productId,taskId,path,name,status) VALUES(?,?,?,?,?)',
        [
          downloadTaskProgress.productId,
          downloadTaskProgress.taskId,
          downloadTaskProgress.storagePath,
          downloadTaskProgress.videoName,
          'STARTED'
        ]);
  }

  getAllDownloadedData() async {
    List<Map> list = await database.rawQuery('SELECT * FROM DownloadVideo');

    Logger().d("GEL ALL DATA: $list");
    List<DownloadTaskProgress> downloadedVideos = new List();
    for (final data in list) {
      downloadedVideos.add(new DownloadTaskProgress(
        taskId: data['taskId'],
        productId: data['productId'],
        videoName: data['name'],
        storagePath: data['path'],
      ));
    }
    Logger().d("GEL ALL download data: $downloadedVideos");

    offlineVideos.sink.add(downloadedVideos);
  }

  updateDB(DownloadTaskProgress downloadTaskProgress) {
    database
        .rawInsert('UPDATE DownloadVideo SET status = ? WHERE productId = ?', [
      'DONE',
      downloadTaskProgress.productId,
    ]);
  }

  Future<String> checkDBForDownloadedProduct(int productId) async {
    String status;
    bool availableInDB;
    List<DownloadTask> task = await FlutterDownloader.loadTasks();

    ///Only completed task is added to DB
    log("CHECK DOWNLOAD TASK: $task");
    List<Map> list = await database
        .rawQuery('SELECT * FROM DownloadVideo WHERE productId=?', [productId]);
    // Logger().d("CHECKING DB: $list");
    if (list.isNotEmpty)
      availableInDB = true;
    else
      availableInDB = false;

    ///Compare current taskId

    Logger().d("AVAILABILITY DB: $availableInDB");
    if (availableInDB) {
      ///check current download task
      for (final tempTask in task) {
        // print(
        //     "temp task id: ${tempTask.taskId} ,  list task id: ${list[0]['taskId']}");
        if (tempTask.taskId == list[0]['taskId'] &&
            list[0]['status'] == "DONE") {
          status = "OFFLINE";
          break;
        } else if (tempTask.taskId == list[0]['taskId'] &&
            list[0]['status'] == "STARTED") {
          status = "IN-PROGRESS";
          break;
        } else
          status = "NOT-OFFLINE";
      }
    } else {
      status = "NOT-OFFLINE";
    }

    return status;
  }
}
