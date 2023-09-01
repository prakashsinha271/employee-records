import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/employee.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'emp_db.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: onCreate,
    );
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE empTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        role TEXT,
        joiningDate TEXT,
        exitDate TEXT
      )
    ''');
  }

  Future<void> insertData(String name, String role, String joiningDate, String? exitDate) async {
    final db = await database;
    await db.insert(
      'empTable',
      {
        'name': name,
        'role': role,
        'joiningDate': joiningDate,
        'exitDate': exitDate,
      },
    );
  }

  Future<List<Employee>> getAllEmployees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('empTable');

    return List.generate(maps.length, (index) {
      return Employee(
        id: maps[index]['id'],
        name: maps[index]['name'],
        role: maps[index]['role'],
        joiningDate: maps[index]['joiningDate'],
        exitDate: maps[index]['exitDate'],
      );
    });
  }

  Future<bool> isTableExists(String tableName) async {
    final db = await database;
    var tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'");
    return tables.isNotEmpty;
  }

  Future<int> deleteEmployee(int id) async {
    final db = await instance.database;
    return await db.delete('empTable', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> undoDeleteEmployee(Employee employee) async {
    final db = await instance.database;
    return await db.insert('empTable', employee.toMap());
  }

  Future<void> updateEmployee(Employee employee) async {
    final db = await instance.database;
    await db.update(
      'empTable',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

}
