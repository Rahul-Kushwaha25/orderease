import '../../features/order/domain/entities/order_line_item_entity.dart';
import 'date_utils.dart' as app;

class OrderFormatter {
  OrderFormatter._();

  static String format({
    required String shopName,
    required List<OrderLineItemEntity> items,
    required double totalPrice,
  }) {
    final buffer = StringBuffer();
    final date = app.DukaanDateUtils.formatOrderDate(DateTime.now());

    buffer.writeln('🛒 Order from: $shopName');
    buffer.writeln('📅 Date: $date');
    buffer.writeln();

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      buffer.writeln(
        '${i + 1}. ${item.itemName} (${item.unit})'
        '${' ' * _padding(item.itemName)}x${item.quantity}'
        '${' ' * 4}₹${item.pricePerUnit.toStringAsFixed(0)}',
      );
    }

    buffer.writeln();
    buffer.writeln('💰 Total: ₹${totalPrice.toStringAsFixed(0)}');
    buffer.writeln();
    buffer.write('Sent via DukaanOrder');

    return buffer.toString();
  }

  static int _padding(String name) => name.length < 20 ? 20 - name.length : 1;
}
