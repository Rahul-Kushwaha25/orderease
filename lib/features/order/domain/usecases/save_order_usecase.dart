import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class SaveOrderUseCase {
  const SaveOrderUseCase(this._repository);

  final OrderRepository _repository;

  Future<void> call(OrderEntity order) async {
    return _repository.saveOrder(order);
  }
}
