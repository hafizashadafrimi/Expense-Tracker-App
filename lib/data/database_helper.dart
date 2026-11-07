import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/transaction_item.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static const databaseName = 'expense_tracker.db';
  static const tableName = 'transactions';

  Database? _database;

  Future<Database> get database async {
    final existing = _database;
    if (existing != null) {
      return existing;
    }
    final opened = await _open();
    _database = opened;
    return opened;
  }

  Future<void> close() async {
    final existing = _database;
    _database = null;
    await existing?.close();
  }

  Future<Database> _open() async {
    final directory = await getDatabasesPath();
    final path = join(directory, databaseName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            amount REAL,
            category TEXT,
            type TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<List<TransactionItem>> getAll() async {
    final db = await database;
    final rows = await db.query(
      tableName,
      orderBy: 'date DESC, id DESC',
    );
    return rows.map(TransactionItem.fromMap).toList();
  }

  Future<int> insert(TransactionItem item) async {
    final db = await database;
    return db.insert(tableName, item.toMap());
  }

  Future<int> update(TransactionItem item) async {
    final db = await database;
    return db.update(
      tableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
