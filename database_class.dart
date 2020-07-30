import 'dart:io';

import 'package:sqflite/sqflite.dart'; //sqflite: ^1.3.0
import 'package:path_provider/path_provider.dart'; //path_provider: ^1.6.11

class DatabaseClass {
  static DatabaseClass _databaseUtil;
  static Database _dataBase;

  DatabaseClass._createInstance();

  factory DatabaseClass() {
    if (_databaseUtil == null) {
      _databaseUtil = DatabaseClass._createInstance();
    }
    return _databaseUtil;
  }

  Future<Database> get database async {
    if (_dataBase == null) {
      _dataBase = await initializeDatabase();
    }
    return _dataBase;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'Agenda2020.db';

    var contatosDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return contatosDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    try {
      ddl.forEach((element) async {
        await db.execute(element);
      });
    } catch (e) {
      print(e);
    }
  }

  List<String> ddl = [
    "CREATE TABLE IF NOT EXISTS table1 (id int, col1 varchar, col2 varchar(20));",
    "CREATE TABLE IF NOT EXISTS table2 (id int, col1 date, col2 char(3));"
  ];

  Future<List> rawQuery(String query) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(query);

    return result;
  }

  Future<int> insertData(String table, Map data) async {
    Database db = await this.database;

    var resultado = await db.insert(table, data);

    return resultado;
  }

  Future<int> updateData(String table, Map data,
      {String where, List whereArgs}) async {
    var db = await this.database;

    var result =
        await db.update(table, data, where: where, whereArgs: whereArgs);

    return result;
  }

  Future<int> deleteData(String table, String where, List whereArgs) async {
    var db = await this.database;

    int result = await db.delete(table, where: where, whereArgs: whereArgs);

    return result;
  }

  Future close() async {
    Database db = await this.database;
    db.close();
  }
}
