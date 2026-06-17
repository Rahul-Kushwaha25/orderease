class DbConstants {
  DbConstants._();

  static const String dbName = 'dukaanorder.db';
  static const int dbVersion = 1;

  // items table
  static const String itemsTable = 'items';
  static const String itemId = 'id';
  static const String itemName = 'name';
  static const String itemPrice = 'price';
  static const String itemUnit = 'unit';
  static const String itemIconId = 'icon_id';
  static const String itemCategory = 'category';
  static const String itemCreatedAt = 'created_at';

  // orders table
  static const String ordersTable = 'orders';
  static const String orderId = 'id';
  static const String orderItemsJson = 'items_json';
  static const String orderTotalPrice = 'total_price';
  static const String orderCreatedAt = 'created_at';
}
