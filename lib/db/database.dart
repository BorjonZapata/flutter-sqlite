import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite/planetas/planetas.dart';
import 'dart:io';

class DB {
  static Future<sqlite.Database> db() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "solarsystem.db");
    return sqlite.openDatabase(
      path,
      version: 1,
      singleInstance: true,
      onCreate: (db, version) async {
        await create(db);
      },
    );
  }

  static Future<void> create(sqlite.Database db) async {
    const String sql = """
      create table planeta (
      id integer primary key autoincrement not null,
      nombre text not null,
      distanciaSol real not null,
      radio real not null,
      createdAt timestamp not null default CURRENT_TIMESTAMP
      )
    """;
    await db.execute(sql);
  }

  static Future<List<Planetas>> consulta() async {
    final sqlite.Database db = await DB.db();
    final List<Map<String, dynamic>> query = await db.query("planeta");
    List<Planetas>? planetario = [];
    planetario = query.map(
          (e) {
        return Planetas.deMapa(e);
      },
    ).toList();
    db.close();
    return planetario;
  }

  static Future<int> insertar(List<Planetas> planetario) async {
    final sqlite.Database db = await DB.db();
    int value = 0;
    for (Planetas planeta in planetario) {
      value = await db.insert("planeta", planeta.mapeador(),
          conflictAlgorithm: sqlite.ConflictAlgorithm.replace);
    }
    db.close();
    return value;
  }

  static Future<void> borrar(int id) async {
    final sqlite.Database db = await DB.db();
    await db.delete("planeta", where: "id = ?", whereArgs: [id]);
    db.close();
  }
}