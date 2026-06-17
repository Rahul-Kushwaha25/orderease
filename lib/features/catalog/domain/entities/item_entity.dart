import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  const ItemEntity({
    this.id,
    required this.name,
    required this.price,
    required this.unit,       // 'kg' | 'gram' | 'litre' | 'ml' | 'unit' | 'packet' | 'dozen'
    required this.iconId,     // key from IconConstants (e.g. 'ic_dairy', 'ic_grain')
    required this.category,   // display category name
    required this.createdAt,
  });

  final int? id;
  final String name;
  final double price;
  final String unit;
  final String iconId;
  final String category;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, name, price, unit, iconId, category, createdAt];
}
