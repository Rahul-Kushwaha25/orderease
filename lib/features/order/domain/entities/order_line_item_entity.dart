import 'package:equatable/equatable.dart';

class OrderLineItemEntity extends Equatable {
  const OrderLineItemEntity({
    required this.itemName,
    required this.unit,
    required this.quantity,
    required this.pricePerUnit,
    required this.lineTotal,
  });

  final String itemName;
  final String unit;
  final int quantity;
  final double pricePerUnit;
  final double lineTotal;

  @override
  List<Object?> get props => [itemName, unit, quantity, pricePerUnit, lineTotal];
}
