
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:projet/Model/Membre.dart';
import 'package:sqflite/sqflite.dart' as sql ;
import 'package:path/path.dart';
import 'dart:io' as io;


class MEMBREHelper {
  static get table => 'membres';
  static get id => 'id';
  static get nom => 'nom';
  static get email => 'email';
  static get telephone_1 => 'telephone_1';
  static get telephone_2 => 'telephone_2';
  static const String DB_Name = 'gstock.db';

  static Future<void> createTable(sql.Database database) async {


    await database.execute("""CREATE TABLE IF NOT EXISTS $table (
        $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $nom TEXT,
        $email TEXT,
        $telephone_1 INTEGER,
        $telephone_2 INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }


  // id: the id of a Membre
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

  // Create new Membre
  static Future<int> createMembre(Membre membre) async {
    final db = await MEMBREHelper.db();


    final id = await db.insert(table, membre.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all Membres
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await MEMBREHelper.db();
    await createTable(db);
    return db.query(table, orderBy: id);

  }

  // Read a single Membre by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<Map<String, dynamic>?> getItem(int id) async {
    var db = await MEMBREHelper.db();
    var res = await  db.query(table, where: "id = ?", whereArgs: [id], limit: 1);
    if (res.length > 0) {
      return res.first;
    }
  }

  // Update an Membre by id
  static Future<int> updateMembre(
      int id, Membre membre) async {
    final db = await MEMBREHelper.db();
    membre.id=id;
    final result =
    await db.update(table, membre.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteMembre(int id) async {
    final db = await MEMBREHelper.db();
    try {
      await db.delete(table, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}