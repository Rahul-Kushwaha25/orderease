import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class LoadHomeItems extends HomeEvent {
  const LoadHomeItems();
}

final class ToggleViewMode extends HomeEvent {
  const ToggleViewMode();
}

final class AddToCart extends HomeEvent {
  const AddToCart({required this.itemId});
  final int itemId;

  @override
  List<Object?> get props => [itemId];
}

final class RemoveFromCart extends HomeEvent {
  const RemoveFromCart({required this.itemId});
  final int itemId;

  @override
  List<Object?> get props => [itemId];
}
