import 'package:equatable/equatable.dart';
import '../../../catalog/domain/entities/item_entity.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.items,
    required this.cart, // Map of ItemId to Quantity
    required this.isGrouped,
  });

  final List<ItemEntity> items;
  final Map<int, int> cart;
  final bool isGrouped;

  int get cartCount => cart.values.fold(0, (total, qty) => total + qty);

  @override
  List<Object?> get props => [items, cart, isGrouped];
}

final class HomeError extends HomeState {
  const HomeError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
