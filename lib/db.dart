import 'dart:ffi';

import 'package:instadam/createPost.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class db {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await openDatabase(
      join(await getDatabasesPath(), 'instadam.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, user TEXT, pass TEXT, posts INTEGER)',
        );
        await db.execute(
          'CREATE TABLE posts(id INTEGER PRIMARY KEY AUTOINCREMENT, rutaImagen TEXT, user TEXT, desc TEXT, fecha TEXT, likes INTEGER, comentarios INTEGER)',
        );
        await db.execute(
          'CREATE TABLE comentarios(id INTEGER PRIMARY KEY AUTOINCREMENT, idPost TEXT, user TEXT, contenido TEXT, fecha TEXT)',
        );
        await db.execute(
          'CREATE TABLE post_likes(post_id INTEGER, user TEXT, PRIMARY KEY (post_id, user))',
        );
      },
    );
    return _database!;
  }

  static Future<bool> login(String user, String pass) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'user = ? AND pass = ?',
      whereArgs: [user, pass],
    );
    return result.isNotEmpty;
  }

  static Future<void> register(String user, String pass) async {
    final db = await database;
    await db.insert('users', {'user': user, 'pass': pass});
  }

  static Future<void> createPost(String rutaImagen, String user, String desc, String fecha) async {
    final db = await database;
    await db.insert('posts', {
      'rutaImagen': rutaImagen,
      'user': user,
      'desc': desc,
      'fecha': fecha,
      'likes': 0,
      'comentarios': 0
    });

    await db.rawUpdate(
      'UPDATE users SET posts = COALESCE(posts, 0) + 1 WHERE user = ?',
      [user],
    );

    print('Post creat: user=$user, desc=$desc, fecha=$fecha');
  }

  static Future<List<Map<String, dynamic>>> getPosts() async {
    final db = await database;
    final result = await db.query('posts', orderBy: 'id DESC');
    return result;
  }

  static Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUser');
  }

  static Future<void> like(int postId) async {
    final db = await database;
    final user = await getCurrentUser();
    if (user == null) return;

    try {
      await db.insert('post_likes', {
        'post_id': postId,
        'user': user,
      });
      await db.rawUpdate(
        'UPDATE posts SET likes = likes + 1 WHERE id = ?',
        [postId],
      );
    } catch (e) {}
  }

  static Future<List<Map<String, dynamic>>> getComentarios(int idPost) async {
    final dbConn = await database;
    return await dbConn.query(
      'comentarios',
      where: 'idPost = ?',
      whereArgs: [idPost],
      orderBy: 'id DESC',
    );
  }

  static Future<void> addComentario(int idPost, String user, String contenido, String fecha) async {
    final dbConn = await database;
    await dbConn.insert('comentarios', {
      'idPost': idPost,
      'user': user,
      'contenido': contenido,
      'fecha': fecha,
    });

    await dbConn.rawUpdate(
      'UPDATE posts SET comentarios = comentarios + 1 WHERE id = ?',
      [idPost],
    );
  }
}
