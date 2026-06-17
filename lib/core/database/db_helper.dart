import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/db_constants.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final pathString = join(dbPath, DbConstants.dbName);

    return await openDatabase(
      pathString,
      version: DbConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DbConstants.itemsTable} (
        ${DbConstants.itemId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbConstants.itemName} TEXT NOT NULL,
        ${DbConstants.itemPrice} REAL NOT NULL,
        ${DbConstants.itemUnit} TEXT NOT NULL,
        ${DbConstants.itemIconId} TEXT NOT NULL,
        ${DbConstants.itemCategory} TEXT NOT NULL,
        ${DbConstants.itemCreatedAt} INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.ordersTable} (
        ${DbConstants.orderId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbConstants.orderItemsJson} TEXT NOT NULL,
        ${DbConstants.orderTotalPrice} REAL NOT NULL,
        ${DbConstants.orderCreatedAt} INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Standard version-based migration placeholder
  }
}
