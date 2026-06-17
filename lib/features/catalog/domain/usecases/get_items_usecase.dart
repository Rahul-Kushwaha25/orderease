import '../entities/item_entity.dart';
import '../repositories/item_repository.dart';

class GetItemsUseCase {
  const GetItemsUseCase(this._repository);

  final ItemRepository _repository;

  Future<List<ItemEntity>> call() async {
    return _repository.getAllItems();
  }
}
