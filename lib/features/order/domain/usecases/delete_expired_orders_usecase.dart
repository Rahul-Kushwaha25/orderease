import '../../../../core/constants/app_constants.dart';
import '../repositories/order_repository.dart';

class DeleteExpiredOrdersUseCase {
  const DeleteExpiredOrdersUseCase(this._repository);

  final OrderRepository _repository;

  Future<void> call() async {
    final cutoff = DateTime.now().subtract(
      const Duration(days: AppConstants.orderRetentionDays),
    );
    return _repository.deleteOrdersBefore(cutoff);
  }
}
