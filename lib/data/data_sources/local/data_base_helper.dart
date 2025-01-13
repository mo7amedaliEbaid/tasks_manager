import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;
  static Database? _userDatabase;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> get userDatabase async {
    if (_userDatabase != null) return _userDatabase!;

    _userDatabase = await _initUserDatabase();
    return _userDatabase!;
  }

  Future<Database> _initUserDatabase() async {
    final dbPath = await getDatabasesPath();

    return openDatabase(join(dbPath, "user.db"), onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, password TEXT)");
    }, version: 1);
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();

    return openDatabase(join(dbPath, "notes.db"), onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT)");
    }, version: 2);
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return db.query("notes", orderBy: 'id DESC');
  }

  Future<Map<String, dynamic>?> getUser(int id) async {
    final db = await userDatabase;
    final results = await db.query(
      "user",
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> addUser(String name, String password) async {
    final db = await userDatabase;
    return db.insert(
      "user",
      {
        'name': name,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateUser(
      int id, String name, String email, String password) async {
    final db = await userDatabase;
    return db.update(
      "user",
      {
        'name': name,
        'password': password,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await userDatabase;
    return db.delete(
      "user",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> addNote(String title, String content) async {
    final db = await database;
    return db.insert(
        "notes",
        {
          'title': title,
          'content': content,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateNote(int id, String title, String content) async {
    final db = await database;
    return db.update(
      "notes",
      {
        'title': title,
        'content': content,
      },
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<int> deleteNote(int id,) async {
    final db = await database;
    return db.delete(
      "notes",
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
