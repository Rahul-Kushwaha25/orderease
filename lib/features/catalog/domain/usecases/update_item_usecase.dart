import '../entities/item_entity.dart';
import '../repositories/item_repository.dart';

class UpdateItemUseCase {
  const UpdateItemUseCase(this._repository);

  final ItemRepository _repository;

  Future<void> call(ItemEntity item) async {
    return _repository.updateItem(item);
  }
}
