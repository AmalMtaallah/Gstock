
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:projet/Model/Categorie.dart';
import 'package:sqflite/sqflite.dart' as sql ;
import 'package:path/path.dart';
import 'dart:io' as io;


class CATEGORYHelper {
  static get table => 'categories';
  static get id => 'id';
  static get categorie => 'categorie';
  static const String DB_Name = 'gstock.db';

  static Future<void> createTable(sql.Database database) async {


    await database.execute("""CREATE TABLE IF NOT EXISTS $table (
        $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $categorie TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }


  // id: the id of a Categorie
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_Name);
    return sql.openDatabase(
      path,
      version: 2,
      onCreate: (sql.Database database, int version) async {
        await createTable(database);
      },
    );
  }

  // Create new category
  static Future<int> create(Categorie categorie) async {
    final db = await CATEGORYHelper.db();


    final id = await db.insert(table, categorie.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all categories
  static Future<List<Map<String, dynamic>>> getAll() async {

    final db = await CATEGORYHelper.db();
    await createTable(db);
    return db.query(table, orderBy: id);

  }

  // Read a single category by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<Map<String, dynamic>?> getOne(int id) async {
    var db = await CATEGORYHelper.db();
    var res = await  db.query(table, where: "id = ?", whereArgs: [id], limit: 1);
    if (res.isNotEmpty) {
      return res.first;
    }
  }

  // Update a category by id
  static Future<int> update(
      int id, Categorie categorie) async {
    final db = await CATEGORYHelper.db();
    categorie.id=id;
    final result =
    await db.update(table, categorie.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> delete(int id) async {
    final db = await CATEGORYHelper.db();
    try {
      await db.delete(table, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}