import 'package:equatable/equatable.dart';
import '../../domain/entities/item_entity.dart';

sealed class CatalogState extends Equatable {
  const CatalogState();

  @override
  List<Object?> get props => [];
}

final class CatalogInitial extends CatalogState {
  const CatalogInitial();
}

final class CatalogLoading extends CatalogState {
  const CatalogLoading();
}

final class CatalogLoaded extends CatalogState {
  const CatalogLoaded({required this.items});
  final List<ItemEntity> items;

  @override
  List<Object?> get props => [items];
}

final class CatalogError extends CatalogState {
  const CatalogError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

final class CatalogItemOperationSuccess extends CatalogState {
  const CatalogItemOperationSuccess();
}
