import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tienda/controller/download-controller.dart';

class DBController {
  Database database;

  DBController._privateConstructor();

  static final DBController _instance = DBController._privateConstructor();

  factory DBController() {
    return _instance;
  }

  String get path => null;

  initializeDB() async {
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      Logger().d("OPEN DB IS SUCCESS: ${db.path}");
      await db.execute(
          'CREATE TABLE DownloadVideo (id INTEGER PRIMARY KEY, path TEXT, name TEXT)');
    });
  }

  insertData(DownloadTaskProgress downloadTaskProgress) {

    database.rawInsert(
        'INSERT INTO DownloadVideo(${downloadTaskProgress.productId}, ${downloadTaskProgress.storagePath}, ${downloadTaskProgress.videoName}) VALUES("some name", 1234, 456.789)');
  }

  queryData() async {
    List<Map> list = await database.rawQuery('SELECT * FROM DownloadVideo');

    ///Convert to list of downloaded task
    // List<Map> expectedList = [
    //   {'name': 'updated name', 'id': 1, 'path': '9876'},
    //   {'name': 'another name', 'id': 2, 'path': 12345678}
    // ];
  }
}
