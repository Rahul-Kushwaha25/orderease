import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

final class OrderInitial extends OrderState {
  const OrderInitial();
}

final class OrderLoading extends OrderState {
  const OrderLoading();
}

final class OrderSavedState extends OrderState {
  const OrderSavedState();
}

final class RecentOrdersLoadedState extends OrderState {
  const RecentOrdersLoadedState({required this.orders});
  final List<OrderEntity> orders;

  @override
  List<Object?> get props => [orders];
}

final class OrderErrorState extends OrderState {
  const OrderErrorState({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
