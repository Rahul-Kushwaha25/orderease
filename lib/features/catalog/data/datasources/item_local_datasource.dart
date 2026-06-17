import '../../../../core/database/db_helper.dart';
import '../../../../core/constants/db_constants.dart';

class ItemLocalDataSource {
  const ItemLocalDataSource(this._dbHelper);

  final DatabaseHelper _dbHelper;

  Future<List<Map<String, dynamic>>> fetchAllItems() async {
    final db = await _dbHelper.database;
    return db.query(DbConstants.itemsTable, orderBy: '${DbConstants.itemCreatedAt} DESC');
  }

  Future<int> insertItem(Map<String, dynamic> itemMap) async {
    final db = await _dbHelper.database;
    return db.insert(DbConstants.itemsTable, itemMap);
  }

  Future<int> updateItem(Map<String, dynamic> itemMap, int id) async {
    final db = await _dbHelper.database;
    return db.update(
      DbConstants.itemsTable,
      itemMap,
      where: '${DbConstants.itemId} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      DbConstants.itemsTable,
      where: '${DbConstants.itemId} = ?',
      whereArgs: [id],
    );
  }
}
