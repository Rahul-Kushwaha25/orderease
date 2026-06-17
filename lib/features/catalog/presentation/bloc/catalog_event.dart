import 'package:equatable/equatable.dart';
import '../../domain/entities/item_entity.dart';

sealed class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => [];
}

final class LoadCatalogItems extends CatalogEvent {
  const LoadCatalogItems();
}

final class AddCatalogItem extends CatalogEvent {
  const AddCatalogItem({required this.item});
  final ItemEntity item;

  @override
  List<Object?> get props => [item];
}

final class UpdateCatalogItem extends CatalogEvent {
  const UpdateCatalogItem({required this.item});
  final ItemEntity item;

  @override
  List<Object?> get props => [item];
}

final class DeleteCatalogItem extends CatalogEvent {
  const DeleteCatalogItem({required this.itemId});
  final int itemId;

  @override
  List<Object?> get props => [itemId];
}
