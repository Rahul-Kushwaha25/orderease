import '../../../../core/database/db_helper.dart';
import '../../../../core/constants/db_constants.dart';

class OrderLocalDataSource {
  const OrderLocalDataSource(this._dbHelper);

  final DatabaseHelper _dbHelper;

  Future<List<Map<String, dynamic>>> fetchRecentOrders() async {
    final db = await _dbHelper.database;
    return db.query(DbConstants.ordersTable, orderBy: '${DbConstants.orderCreatedAt} DESC');
  }

  Future<int> insertOrder(Map<String, dynamic> orderMap) async {
    final db = await _dbHelper.database;
    return db.insert(DbConstants.ordersTable, orderMap);
  }

  Future<int> deleteOrdersOlderThan(int timestamp) async {
    final db = await _dbHelper.database;
    return db.delete(
      DbConstants.ordersTable,
      where: '${DbConstants.orderCreatedAt} < ?',
      whereArgs: [timestamp],
    );
  }
}
