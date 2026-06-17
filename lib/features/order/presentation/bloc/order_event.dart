import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

final class SaveOrderEvent extends OrderEvent {
  const SaveOrderEvent({required this.order});
  final OrderEntity order;

  @override
  List<Object?> get props => [order];
}

final class LoadRecentOrdersEvent extends OrderEvent {
  const LoadRecentOrdersEvent();
}
