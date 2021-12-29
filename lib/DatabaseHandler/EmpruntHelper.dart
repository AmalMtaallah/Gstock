
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:projet/Model/Categorie.dart';
import 'package:projet/Model/Emprunt.dart';
import 'package:sqflite/sqflite.dart' as sql ;
import 'package:path/path.dart';
import 'dart:io' as io;


class EMPRUNTHelper {
  static get table => 'emprunts';
  static get id => 'id';
  static get idMembre => 'idMembre';
  static const String DB_Name = 'gstock.db';

  static Future<void> createTable(sql.Database database) async {

    await database.execute("""CREATE TABLE IF NOT EXISTS $table (
        $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        $idMembre INTEGER FOREIGN KEY  REFERENCES membres (id) ON DELETE NO ACTION ON UPDATE NO ACTION
      )
      """);
  }

  static Future _onConfigure(sql.Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
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
      onConfigure: _onConfigure
    );
  }

  // Create new emprunt
  static Future<int> create(Emprunt emprunt) async {
    final db = await EMPRUNTHelper.db();

    final id = await db.insert(table, emprunt.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all emprunts
  static Future<List<Map<String, dynamic>>> getAll() async {

    final db = await EMPRUNTHelper.db();
    await createTable(db);
    return db.query(table, orderBy: id);

  }

  // Read a single emprunt by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<Map<String, dynamic>?> getOne(int id) async {
    var db = await EMPRUNTHelper.db();
    var res = await  db.query(table, where: "id = ?", whereArgs: [id], limit: 1);
    if (res.isNotEmpty) {
      return res.first;
    }
  }

  // Update an emprunt by id
  static Future<int> update(
      int id, Emprunt emprunt) async {
    final db = await EMPRUNTHelper.db();
    emprunt.id=id;
    final result =
    await db.update(table, emprunt.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> delete(int id) async {
    final db = await EMPRUNTHelper.db();
    try {
      await db.delete(table, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}