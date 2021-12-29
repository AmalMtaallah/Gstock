
import 'package:path_provider/path_provider.dart';
import 'package:projet/Model/Admin.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DbHelper{
  static Database?  _db;
  static const String DB_Name = 'gstock.db';
  static const String Table_Admin = 'admin';
  static const int Version = 1;


  static const String C_UserID = 'admin_id';
  static const String C_UserName = 'admin_name';
  static const String C_Email = 'email';
  static const String C_Password = 'password';

  Future<Database>get db async{
    if(_db == null){
      _db=await initDb();


    }

    return _db!;
  }

  Future<Database> initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_Name);
    var db = await openDatabase(path, version: Version, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE $Table_Admin ("
        " $C_UserID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        " $C_UserName TEXT, "
        " $C_Email TEXT,"
        " $C_Password TEXT )");
  }

  Future<Admin> saveData(Admin user) async {
    var dbClient = await db;
    user.admin_id = (await dbClient.insert(Table_Admin, user.toMap())) as int;
    return user ;
  }

  Future<Admin?> getLoginUser(String userEmail, String password) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_Admin WHERE "
        "$C_Email = '$userEmail' AND "
        "$C_Password = '$password'");

    if (res.length > 0) {
      return Admin.fromMap(res.first);
    }

    return null;
  }


}