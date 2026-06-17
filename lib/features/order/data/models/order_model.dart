import 'dart:convert';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_line_item_entity.dart';
import '../../../../core/constants/db_constants.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    super.id,
    required super.items,
    required super.totalPrice,
    required super.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final rawItemsJson = map[DbConstants.orderItemsJson] as String;
    final List<dynamic> decoded = jsonDecode(rawItemsJson) as List<dynamic>;

    final parsedItems = decoded.map((itemMap) {
      return OrderLineItemEntity(
        itemName: itemMap['itemName'] as String,
        unit: itemMap['unit'] as String,
        quantity: itemMap['quantity'] as int,
        pricePerUnit: (itemMap['pricePerUnit'] as num).toDouble(),
        lineTotal: (itemMap['lineTotal'] as num).toDouble(),
      );
    }).toList();

    return OrderModel(
      id: map[DbConstants.orderId] as int?,
      items: parsedItems,
      totalPrice: (map[DbConstants.orderTotalPrice] as num).toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map[DbConstants.orderCreatedAt] as int),
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      items: entity.items,
      totalPrice: entity.totalPrice,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final serializedItems = items.map((lineItem) {
      return {
        'itemName': lineItem.itemName,
        'unit': lineItem.unit,
        'quantity': lineItem.quantity,
        'pricePerUnit': lineItem.pricePerUnit,
        'lineTotal': lineItem.lineTotal,
      };
    }).toList();

    final map = <String, dynamic>{
      DbConstants.orderItemsJson: jsonEncode(serializedItems),
      DbConstants.orderTotalPrice: totalPrice,
      DbConstants.orderCreatedAt: createdAt.millisecondsSinceEpoch,
    };

    if (id != null) {
      map[DbConstants.orderId] = id;
    }

    return map;
  }
}
