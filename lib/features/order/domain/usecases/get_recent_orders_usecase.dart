import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetRecentOrdersUseCase {
  const GetRecentOrdersUseCase(this._repository);

  final OrderRepository _repository;

  Future<List<OrderEntity>> call() async {
    return _repository.getRecentOrders();
  }
}
