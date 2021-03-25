import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:todo_list/src/models/task_model.dart';

class DBProvider {
  static final DBProvider instance = DBProvider._();
  static Database _database;

  DBProvider._();

  Future<Database> get database async {
    if (_database == null) _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ToDo_List.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: _createDB,
    );
  }

  void _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE Task ('
        ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' title TEXT,'
        ' description TEXT,'
        ' status INTEGER'
        ')');
  }

  // SELECT
  Future<List<TaskModel>> getTaskList() async {
    final db = await database;
    final res = await db.query('Task');

    List<TaskModel> list = res.isNotEmpty
        ? res.map((task) => TaskModel.fromJson(task)).toList()
        : [];

    return list;
  }

  // INSERT
  Future<int> insertTask(TaskModel task) async {
    final db = await database;

    final res = db.insert('Task', task.toJson());
    return res;
  }

  // UPDATE
  Future<int> updateTask(TaskModel task) async {
    final db = await database;

    final res =
        db.update('Task', task.toJson(), where: 'id = ?', whereArgs: [task.id]);

    return res;
  }

  // DELETE
  Future<int> deleteTask(TaskModel task) async {
    final db = await database;

    final res = await db.delete('Task', where: 'id = ?', whereArgs: [task.id]);
    return res;
  }
}
