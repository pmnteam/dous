import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//
import 'package:dous/models/dous_task.dart';
import 'package:dous/models/user.dart';

class DataBase {
  // Constructor
  DataBase._init();
  // An instance of the Database
  static final DataBase instance = DataBase._init();
  // Database instance: Private Fields
  Database? _db;

  Future<Database?> get database async {
    if (_db != null) {
      return _db;
    } else {
      // Will be implemented in step 4
      _db = await _openDatabase('dous.db');
      return _db;
    }
  }

  Future<String> _getDatabasePath(String fileName) async {
    final databasePath = await getDatabasesPath();
    // We need a path for our database
    final path = join(databasePath, fileName);

    return path;
  }

  Future<Database> _openDatabase(String fileName) async {
    final databasebPath = await _getDatabasePath(fileName);

    return await openDatabase(
      databasebPath,
      version: 1,
      // When creating the db, create the table
      // Is called if the database did not exist prior to calling [openDatabase].
      // You can use the opportunity to create the required tables in the database
      // according to your schema

      onCreate: _createDatabaseTables, // Will be implemented in step
      // [onConfigure] is the first callback invoked when opening the database.
      // It allows you to perform database initialization such as
      // enabling foreign keys or write-ahead logging
      onConfigure: _onConfigure, // Will be implemented in step
    );
  }

  Future<void> _createDatabaseTables(Database db, int version) async {
    await db.execute('''CREATE TABLE ${User.userTable} (
        ${UserColumns.email} TEXT NOT NULL,
        ${UserColumns.username} TEXT PRIMARY KEY NOT NULL,
        ${UserColumns.password} TEXT NOT NULL
    )''');

    await db.execute('''CREATE TABLE ${DoUsTask.dousTable} (
        ${DoUsColumns.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ${DoUsColumns.username} TEXT NOT NULL,
        ${DoUsColumns.title} TEXT NOT NULL,
        ${DoUsColumns.dueDate} TEXT NOT NULL,
        ${DoUsColumns.created} TEXT NOT NULL,
        ${DoUsColumns.done} BOOLEAN NOT NULL,
  			${DoUsColumns.important} BOOLEAN NOT NULL,
        FOREIGN KEY (${DoUsColumns.username}) REFERENCES ${User.userTable} (${UserColumns.username})
    )''');
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> close() async {
    final db = await instance.database;
    db!.close();
  }

  // Users
  Future<User> createUser(User user) async {
    final db = await instance.database;
    await db!.insert(User.userTable, user.toMap());
    return user;
  }

  Future<User> getUser(String username) async {
    final db = await instance.database;
    final maps = await db!.query(
      User.userTable,
      columns: UserColumns.allUserColumns,
      where: '${UserColumns.username} = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.getUser(maps.first);
    } else {
      throw Exception('$username not found in the database.');
    }
  }

  Future<int> deleteUser(String username) async {
    final db = await instance.database;
    return db!.delete(
      User.userTable,
      where: '${UserColumns.username} = ?',
      whereArgs: [username],
    );
  }

  Future<DoUsTask> createDousTask(DoUsTask task) async {
    final db = await instance.database;
    await db!.insert(
      DoUsTask.dousTable,
      task.toMap(),
    );
    return task;
  }

  Future<List<DoUsTask>> getDousTasks(String username) async {
    final db = await instance.database;
    final result = await db!.query(
      DoUsTask.dousTable,
      orderBy: '${DoUsColumns.created} DESC',
      where: '${DoUsColumns.username} = ?',
      whereArgs: [username],
    );
    return result.map((e) => DoUsTask.fromMap(e)).toList();
  }

  Future<int> updateDousTask(DoUsTask task) async {
    final db = await instance.database;

    return db!.update(
      DoUsTask.dousTable,
      task.toMap(),
      where: '${DoUsColumns.id} = ? AND ${DoUsColumns.username} = ?',
      whereArgs: [task.id, task.userName],
    );
  }

  Future<int> deleteDousTask(DoUsTask task) async {
    final db = await instance.database;

    return db!.delete(
      DoUsTask.dousTable,
      where: '${DoUsColumns.id} = ? AND ${DoUsColumns.username} = ?',
      whereArgs: [task.id, task.userName],
    );
  }

  Future<int> toggleDousIsDone(DoUsTask task) async {
    final db = await instance.database;
    task.done = !task.done;

    return db!.update(
      DoUsTask.dousTable,
      task.toMap(),
      where: '${DoUsColumns.id} = ? AND ${DoUsColumns.username} = ?',
      whereArgs: [task.id, task.userName],
    );
  }

  Future<int> toggleDousIsImportant(DoUsTask task) async {
    final db = await instance.database;
    task.important = !task.important;

    return db!.update(
      DoUsTask.dousTable,
      task.toMap(),
      where: '${DoUsColumns.id} = ? AND ${DoUsColumns.username} = ?',
      whereArgs: [task.id, task.userName],
    );
  }
}
