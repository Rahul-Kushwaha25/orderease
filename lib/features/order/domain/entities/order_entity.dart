import 'package:equatable/equatable.dart';
import 'order_line_item_entity.dart';

class OrderEntity extends Equatable {
  const OrderEntity({
    this.id,
    required this.items,
    required this.totalPrice,
    required this.createdAt,
  });

  final int? id;
  final List<OrderLineItemEntity> items;
  final double totalPrice;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, items, totalPrice, createdAt];
}
