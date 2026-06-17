import '../repositories/item_repository.dart';

class DeleteItemUseCase {
  const DeleteItemUseCase(this._repository);

  final ItemRepository _repository;

  Future<void> call(int id) async {
    return _repository.deleteItem(id);
  }
}
