import '../../domain/entities/item_entity.dart';
import '../../../../core/constants/db_constants.dart';

class ItemModel extends ItemEntity {
  const ItemModel({
    super.id,
    required super.name,
    required super.price,
    required super.unit,
    required super.iconId,
    required super.category,
    required super.createdAt,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map[DbConstants.itemId] as int?,
      name: map[DbConstants.itemName] as String,
      price: (map[DbConstants.itemPrice] as num).toDouble(),
      unit: map[DbConstants.itemUnit] as String,
      iconId: map[DbConstants.itemIconId] as String,
      category: map[DbConstants.itemCategory] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map[DbConstants.itemCreatedAt] as int),
    );
  }

  factory ItemModel.fromEntity(ItemEntity entity) {
    return ItemModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      unit: entity.unit,
      iconId: entity.iconId,
      category: entity.category,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      DbConstants.itemName: name,
      DbConstants.itemPrice: price,
      DbConstants.itemUnit: unit,
      DbConstants.itemIconId: iconId,
      DbConstants.itemCategory: category,
      DbConstants.itemCreatedAt: createdAt.millisecondsSinceEpoch,
    };
    if (id != null) {
      map[DbConstants.itemId] = id;
    }
    return map;
  }
}
