import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(this._dataSource);

  final OrderLocalDataSource _dataSource;

  @override
  Future<List<OrderEntity>> getRecentOrders() async {
    final maps = await _dataSource.fetchRecentOrders();
    return maps.map(OrderModel.fromMap).toList();
  }

  @override
  Future<void> saveOrder(OrderEntity order) async {
    final model = OrderModel.fromEntity(order);
    await _dataSource.insertOrder(model.toMap());
  }

  @override
  Future<void> deleteOrdersBefore(DateTime cutoff) async {
    final timestamp = cutoff.millisecondsSinceEpoch;
    await _dataSource.deleteOrdersOlderThan(timestamp);
  }
}
