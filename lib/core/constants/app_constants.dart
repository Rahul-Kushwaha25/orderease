class AppConstants {
  AppConstants._();

  // SharedPreferences keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguageCode = 'language_code';
  static const String keyShopName = 'shop_name';
  static const String keySupplierPhone = 'supplier_phone';
  static const String keyHomeViewMode = 'home_view_mode';   // 'flat' | 'grouped'

  // Defaults
  static const String defaultLanguage = 'en';
  static const String defaultTheme = 'light';
  static const String defaultViewMode = 'flat';

  // Order
  static const int orderRetentionDays = 3;
}
