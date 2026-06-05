import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

/// Service for handling SQLite database operations
class DatabaseService {
  static Database? _database;
  
  /// Get database instance (singleton pattern)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'app_database.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  /// Create database tables
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        priority INTEGER NOT NULL DEFAULT 0,
        category TEXT,
        dueDate TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT,
        website TEXT,
        company TEXT,
        address TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color TEXT NOT NULL,
        icon TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        type TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  /// Upgrade database schema
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Handle database migrations here
      // Example: Add new columns, tables, etc.
    }
  }

  /// Generic CRUD Operations
  
  /// Insert record
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  /// Get all records from table
  Future<List<Map<String, dynamic>>> getAll(String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// Get single record by ID
  Future<Map<String, dynamic>?> getById(String table, int id) async {
    final db = await database;
    final results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Update record
  Future<int> update(String table, Map<String, dynamic> data, int id) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete record by ID
  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete records with custom where clause
  Future<int> deleteWhere(String table, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  /// Count records
  Future<int> count(String table, {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $table${where != null ? ' WHERE $where' : ''}',
      whereArgs,
    );
    return result.first['count'] as int;
  }

  /// Execute raw query
  Future<List<Map<String, dynamic>>> rawQuery(String query, [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawQuery(query, arguments);
  }

  /// Execute raw SQL
  Future<void> rawExecute(String sql, [List<dynamic>? arguments]) async {
    final db = await database;
    await db.rawUpdate(sql, arguments);
  }

  /// Batch operations
  Future<List<dynamic>> batch(List<Map<String, dynamic>> operations) async {
    final db = await database;
    final batch = db.batch();
    
    for (final operation in operations) {
      final type = operation['type'] as String;
      final table = operation['table'] as String;
      final data = operation['data'] as Map<String, dynamic>?;
      
      switch (type) {
        case 'insert':
          batch.insert(table, data!);
          break;
        case 'update':
          final id = operation['id'] as int;
          batch.update(table, data!, where: 'id = ?', whereArgs: [id]);
          break;
        case 'delete':
          final id = operation['id'] as int;
          batch.delete(table, where: 'id = ?', whereArgs: [id]);
          break;
      }
    }
    
    return await batch.commit();
  }

  /// Transaction support
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await database;
    return await db.transaction(action);
  }

  /// Clear all data from table
  Future<int> clearTable(String table) async {
    final db = await database;
    return await db.delete(table);
  }

  /// Drop table
  Future<void> dropTable(String table) async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS $table');
  }

  /// Check if table exists
  Future<bool> tableExists(String table) async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$table'",
    );
    return result.isNotEmpty;
  }

  /// Get table schema
  Future<List<Map<String, dynamic>>> getTableInfo(String table) async {
    final db = await database;
    return await db.rawQuery('PRAGMA table_info($table)');
  }

  /// Close database
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}

/// Database table names
class DbTables {
  static const String todos = 'todos';
  static const String users = 'users';
  static const String categories = 'categories';
  static const String settings = 'settings';
}

/// Database utility methods
extension DatabaseServiceExtension on DatabaseService {
  /// Todo-specific operations
  Future<List<Map<String, dynamic>>> getTodos({
    bool? isCompleted,
    String? category,
    int? priority,
  }) async {
    String? where;
    List<dynamic>? whereArgs;

    if (isCompleted != null || category != null || priority != null) {
      final conditions = <String>[];
      whereArgs = <dynamic>[];

      if (isCompleted != null) {
        conditions.add('isCompleted = ?');
        whereArgs.add(isCompleted ? 1 : 0);
      }

      if (category != null) {
        conditions.add('category = ?');
        whereArgs.add(category);
      }

      if (priority != null) {
        conditions.add('priority = ?');
        whereArgs.add(priority);
      }

      where = conditions.join(' AND ');
    }

    return await getAll(
      DbTables.todos,
      where: where,
      whereArgs: whereArgs,
      orderBy: 'createdAt DESC',
    );
  }

  Future<int> addTodo(Map<String, dynamic> todo) async {
    final now = DateTime.now().toIso8601String();
    todo['createdAt'] = now;
    todo['updatedAt'] = now;
    return await insert(DbTables.todos, todo);
  }

  Future<int> updateTodo(int id, Map<String, dynamic> todo) async {
    todo['updatedAt'] = DateTime.now().toIso8601String();
    return await update(DbTables.todos, todo, id);
  }

  Future<int> toggleTodoStatus(int id) async {
    final todo = await getById(DbTables.todos, id);
    if (todo != null) {
      final isCompleted = todo['isCompleted'] as int;
      return await updateTodo(id, {'isCompleted': isCompleted == 1 ? 0 : 1});
    }
    return 0;
  }
}