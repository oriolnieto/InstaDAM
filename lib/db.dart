import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class db {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await openDatabase(
      join(await getDatabasesPath(), 'instadam.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, user TEXT, pass TEXT)', // creem taula amb autoincrementacio y usuari i contra
        );
      },
    );
    return _database!;
  }

  static Future<bool> login(String user, String pass) async {
    final db = await database;
    final result = await db.query('users', where: 'user = $user AND pass = $pass');
    return result.isNotEmpty;
  }

  static Future<void> register(String user, String pass) async { // funcio per a registrar
    final db = await database;
    await db.insert('users', {'user': user, 'pass': pass});
  }
}