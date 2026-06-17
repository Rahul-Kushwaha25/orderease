import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getRecentOrders();
  Future<void> saveOrder(OrderEntity order);
  Future<void> deleteOrdersBefore(DateTime cutoff);
}
