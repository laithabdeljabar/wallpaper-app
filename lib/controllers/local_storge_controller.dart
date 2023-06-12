// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart' as path;
import 'package:wallpaper_app/model/photo.dart';

class LocalStorgeController {
  static const _databaseNmae = "image_data_base";
  static const _databaseVersion = 1;
  static Database? database;
  Future<Database> get myDatabase async {
    if (database != null) {
      return database!;
    }
    database = await _initDatabase();
    return database!;
  }

  _initDatabase() async {
    String defaultPath = await getDatabasesPath();
    String mainPath = path.join(defaultPath, _databaseNmae);
    Database myDb = await openDatabase(mainPath,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpdate);
    return myDb;
  }

  _onUpdate(Database database, int x, int i) {}
  _onCreate(Database database, int version) {
    database.execute(''' 

    CREATE TABLE IF NOT EXISTS WALLPAPER_TABLE(
      id               INTEGER  NOT NULL PRIMARY KEY 
 
  ,portrait     VARCHAR(200) NOT NULL
  ,original          VARCHAR(200) NOT NULL

    )
''');
  }

  Future<void> addPhotoToFavorite(Map<String, Object?> myRecord) async {
    try {
      final db = await myDatabase;
      final batch = db.batch();
      batch.insert("WALLPAPER_TABLE", myRecord);
      await batch.commit();
    } catch (e) {
      log(e.toString());
      throw Exception();
    }
  }

  Future<int> removeFromFavorite(int id) async {
    final db = await myDatabase;
    final res =
        await db.rawDelete("DELETE FROM WALLPAPER_TABLE WHERE id=$id", []);
    return res;
  }

  Future<List<Photo>> getSqlPhotos() async {
    final db = await myDatabase;
    List<Map<String, dynamic>> res =
        await db.rawQuery("SELECT * FROM WALLPAPER_TABLE", []);
    List<Photo> photos = res.isNotEmpty
        ? res
            .map((x) => Photo(
                id: x["id"], original: x["original"], portrait: x["portrait"]))
            .toList()
        : [];
    return photos;
  }
}
