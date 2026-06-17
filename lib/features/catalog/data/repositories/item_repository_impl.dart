import '../../domain/entities/item_entity.dart';
import '../../domain/repositories/item_repository.dart';
import '../datasources/item_local_datasource.dart';
import '../models/item_model.dart';

class ItemRepositoryImpl implements ItemRepository {
  const ItemRepositoryImpl(this._dataSource);

  final ItemLocalDataSource _dataSource;

  @override
  Future<List<ItemEntity>> getAllItems() async {
    final maps = await _dataSource.fetchAllItems();
    return maps.map(ItemModel.fromMap).toList();
  }

  @override
  Future<void> addItem(ItemEntity item) async {
    final model = ItemModel.fromEntity(item);
    await _dataSource.insertItem(model.toMap());
  }

  @override
  Future<void> updateItem(ItemEntity item) async {
    final model = ItemModel.fromEntity(item);
    await _dataSource.updateItem(model.toMap(), item.id!);
  }

  @override
  Future<void> deleteItem(int id) async {
    await _dataSource.deleteItem(id);
  }
}
