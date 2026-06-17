import '../entities/item_entity.dart';
import '../repositories/item_repository.dart';

class AddItemUseCase {
  const AddItemUseCase(this._repository);

  final ItemRepository _repository;

  Future<void> call(ItemEntity item) async {
    return _repository.addItem(item);
  }
}
