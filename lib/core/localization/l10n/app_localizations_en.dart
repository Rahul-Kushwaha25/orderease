// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'DukaanOrder';

  @override
  String get homeTitle => 'DukaanOrder';

  @override
  String get catalogTitle => 'Item Catalog';

  @override
  String get profileTitle => 'Store Profile';

  @override
  String get previewOrderButton => 'Preview Order';

  @override
  String get addItemButton => 'Add Stock Item';

  @override
  String get editItemButton => 'Edit Item';

  @override
  String get deleteItemButton => 'Delete Item';

  @override
  String get itemNameLabel => 'Item Name';

  @override
  String get itemPriceLabel => 'Price (₹)';

  @override
  String get itemUnitLabel => 'Unit of Measurement';

  @override
  String get itemCategoryLabel => 'Category';

  @override
  String get unitKg => 'kg';

  @override
  String get unitGram => 'gram';

  @override
  String get unitLitre => 'litre';

  @override
  String get unitMl => 'ml';

  @override
  String get unitUnit => 'unit';

  @override
  String get unitPacket => 'packet';

  @override
  String get unitDozen => 'dozen';

  @override
  String get flatViewLabel => 'List View';

  @override
  String get groupedViewLabel => 'Grouped View';

  @override
  String get orderPreviewTitle => 'Verify Order Stock';

  @override
  String get copyButton => 'Copy Order Text';

  @override
  String get sendWhatsappButton => 'Send on WhatsApp';

  @override
  String get totalLabel => 'Total Amount';

  @override
  String get orderDateLabel => 'Order Date';

  @override
  String get orderItemsLabel => 'Ordered Items';

  @override
  String get shopNameLabel => 'Shop/Dukaan Name';

  @override
  String get supplierPhoneLabel => 'Supplier WhatsApp Number';

  @override
  String get previousOrdersLabel => 'Recent Order History';

  @override
  String get languageLabel => 'Language / भाषा';

  @override
  String get themeLabel => 'App Theme Mode';

  @override
  String get lightTheme => 'Light Mode';

  @override
  String get darkTheme => 'Dark Mode';

  @override
  String get signInTitle => 'Welcome to DukaanOrder';

  @override
  String get signInButton => 'Sign In with Google';

  @override
  String get signOutButton => 'Log Out / Exit';

  @override
  String get deleteConfirmTitle => 'Remove Item?';

  @override
  String get deleteConfirmMessage =>
      'Are you sure you want to delete this item from your catalog?';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get confirmButton => 'Delete';

  @override
  String get noItemsMessage => 'No items in catalog. Tap \'+\' to create some!';

  @override
  String get noOrdersMessage => 'No recent orders found.';

  @override
  String get supplierPhoneEmptyError =>
      'Please configure your supplier\'s WhatsApp number in your Profile first.';

  @override
  String get whatsappNotInstalledError =>
      'WhatsApp is not installed on this device.';

  @override
  String get loadingMessage => 'Loading catalog stock...';

  @override
  String get errorRetryButton => 'Retry Connection';

  @override
  String get orderSavedMessage => 'Order saved successfully!';

  @override
  String get itemAddedMessage => 'Item added to catalog!';

  @override
  String get itemUpdatedMessage => 'Item updated successfully!';

  @override
  String get itemDeletedMessage => 'Item deleted from catalog!';

  @override
  String get copiedToClipboardMessage => 'Order details copied to clipboard!';

  @override
  String get preferencesSection => 'Preferences';

  @override
  String get languagePreference => 'Language';

  @override
  String get themePreference => 'Theme';

  @override
  String get editShopNameTitle => 'Edit Shop Name';

  @override
  String get enterShopNameHint => 'Enter Shop Name';

  @override
  String get saveButton => 'Save';

  @override
  String get editSupplierPhoneTitle => 'Edit Supplier WhatsApp';
}
