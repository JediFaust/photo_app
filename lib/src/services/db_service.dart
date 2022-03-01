import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBService {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'photos.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE photos(id TEXT PRIMARY KEY, image TEXT, latitude REAL, longitude REAL)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBService.database();
    await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBService.database();
    return db.query(table);
  }
}
