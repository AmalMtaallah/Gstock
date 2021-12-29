import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:projet/Model/Composant.dart';
import 'package:projet/Model/Retour.dart';
import 'package:sqflite/sqflite.dart' as sql ;
import 'package:path/path.dart';
import 'dart:io' as io;

class RetourHelper {
  static get table => 'retours';
  static get id => 'id';
  //atic get dateRetour => 'dateRetour';
  static get etat => 'etat';
  static get qte => 'qte';
  static get idMembre => 'idMembre';
  static get idComposant=>'idComposant';
  static const String DB_Name = 'gstock.db';


  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $table (
        $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $etat TEXT,
        $qte INTEGER,
        $idMembre INTEGER,
        $idComposant INTEGER,
        dateRetour DATE DEFAULT (datetime('now','localtime')),
       
        FOREIGN KEY ($idMembre)  REFERENCES membres (id) ON DELETE NO ACTION ON UPDATE NO ACTION
        FOREIGN KEY ($idComposant)  REFERENCES composants (matricule) ON DELETE NO ACTION ON UPDATE NO ACTION
      )
      """);
  }

  static Future _onConfigure(sql.Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }
// id: the id of a Composant
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


  // Create new Composant (journal)
  static Future<int> createRetour(Retour retour) async {
    final db = await RetourHelper.db();


    final id = await db.insert(table, retour.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all Composants (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await RetourHelper.db();
    await createTable(db);
    return db.query(table, orderBy: id);

  }

  // Read a single Composant by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<Map<String, dynamic>?> getItem(int id) async {
    var db = await RetourHelper.db();
    var res = await  db.query(table, where: "id = ?", whereArgs: [id], limit: 1);
    if (res.isNotEmpty) {
      return res.first;
    }
  }

  // Update a Composant by id
  static Future<int> updateRetour(
      int id, Retour retour) async {
    final db = await RetourHelper.db();
   retour.id=id;
    final result =
    await db.update(table, retour.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteRetour(int id) async {
    final db = await RetourHelper.db();
    try {
      await db.delete(table, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }


}
