import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'DukaanOrder'**
  String get appName;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'DukaanOrder'**
  String get homeTitle;

  /// No description provided for @catalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Item Catalog'**
  String get catalogTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Store Profile'**
  String get profileTitle;

  /// No description provided for @previewOrderButton.
  ///
  /// In en, this message translates to:
  /// **'Preview Order'**
  String get previewOrderButton;

  /// No description provided for @addItemButton.
  ///
  /// In en, this message translates to:
  /// **'Add Stock Item'**
  String get addItemButton;

  /// No description provided for @editItemButton.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItemButton;

  /// No description provided for @deleteItemButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteItemButton;

  /// No description provided for @itemNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemNameLabel;

  /// No description provided for @itemPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (₹)'**
  String get itemPriceLabel;

  /// No description provided for @itemUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit of Measurement'**
  String get itemUnitLabel;

  /// No description provided for @itemCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get itemCategoryLabel;

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// No description provided for @unitGram.
  ///
  /// In en, this message translates to:
  /// **'gram'**
  String get unitGram;

  /// No description provided for @unitLitre.
  ///
  /// In en, this message translates to:
  /// **'litre'**
  String get unitLitre;

  /// No description provided for @unitMl.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get unitMl;

  /// No description provided for @unitUnit.
  ///
  /// In en, this message translates to:
  /// **'unit'**
  String get unitUnit;

  /// No description provided for @unitPacket.
  ///
  /// In en, this message translates to:
  /// **'packet'**
  String get unitPacket;

  /// No description provided for @unitDozen.
  ///
  /// In en, this message translates to:
  /// **'dozen'**
  String get unitDozen;

  /// No description provided for @flatViewLabel.
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get flatViewLabel;

  /// No description provided for @groupedViewLabel.
  ///
  /// In en, this message translates to:
  /// **'Grouped View'**
  String get groupedViewLabel;

  /// No description provided for @orderPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Order Stock'**
  String get orderPreviewTitle;

  /// No description provided for @copyButton.
  ///
  /// In en, this message translates to:
  /// **'Copy Order Text'**
  String get copyButton;

  /// No description provided for @sendWhatsappButton.
  ///
  /// In en, this message translates to:
  /// **'Send on WhatsApp'**
  String get sendWhatsappButton;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalLabel;

  /// No description provided for @orderDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Date'**
  String get orderDateLabel;

  /// No description provided for @orderItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Ordered Items'**
  String get orderItemsLabel;

  /// No description provided for @shopNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop/Dukaan Name'**
  String get shopNameLabel;

  /// No description provided for @supplierPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Supplier WhatsApp Number'**
  String get supplierPhoneLabel;

  /// No description provided for @previousOrdersLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent Order History'**
  String get previousOrdersLabel;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language / भाषा'**
  String get languageLabel;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'App Theme Mode'**
  String get themeLabel;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkTheme;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to DukaanOrder'**
  String get signInTitle;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Google'**
  String get signInButton;

  /// No description provided for @signOutButton.
  ///
  /// In en, this message translates to:
  /// **'Log Out / Exit'**
  String get signOutButton;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Item?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item from your catalog?'**
  String get deleteConfirmMessage;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get confirmButton;

  /// No description provided for @noItemsMessage.
  ///
  /// In en, this message translates to:
  /// **'No items in catalog. Tap \'+\' to create some!'**
  String get noItemsMessage;

  /// No description provided for @noOrdersMessage.
  ///
  /// In en, this message translates to:
  /// **'No recent orders found.'**
  String get noOrdersMessage;

  /// No description provided for @supplierPhoneEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please configure your supplier\'s WhatsApp number in your Profile first.'**
  String get supplierPhoneEmptyError;

  /// No description provided for @whatsappNotInstalledError.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp is not installed on this device.'**
  String get whatsappNotInstalledError;

  /// No description provided for @loadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading catalog stock...'**
  String get loadingMessage;

  /// No description provided for @errorRetryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry Connection'**
  String get errorRetryButton;

  /// No description provided for @orderSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Order saved successfully!'**
  String get orderSavedMessage;

  /// No description provided for @itemAddedMessage.
  ///
  /// In en, this message translates to:
  /// **'Item added to catalog!'**
  String get itemAddedMessage;

  /// No description provided for @itemUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Item updated successfully!'**
  String get itemUpdatedMessage;

  /// No description provided for @itemDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Item deleted from catalog!'**
  String get itemDeletedMessage;

  /// No description provided for @copiedToClipboardMessage.
  ///
  /// In en, this message translates to:
  /// **'Order details copied to clipboard!'**
  String get copiedToClipboardMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
