import '../entities/item_entity.dart';

abstract class ItemRepository {
  Future<List<ItemEntity>> getAllItems();
  Future<void> addItem(ItemEntity item);
  Future<void> updateItem(ItemEntity item);
  Future<void> deleteItem(int id);
}
