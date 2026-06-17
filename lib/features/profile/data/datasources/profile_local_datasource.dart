import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
//import '../models/profile_model.dart' if (dart.library.io) ''; // using standard local mapping

class ProfileLocalDataSource {
  Future<Map<String, String>> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      AppConstants.keyShopName: prefs.getString(AppConstants.keyShopName) ?? 'My Shop',
      AppConstants.keySupplierPhone: prefs.getString(AppConstants.keySupplierPhone) ?? '',
      AppConstants.keyLanguageCode: prefs.getString(AppConstants.keyLanguageCode) ?? AppConstants.defaultLanguage,
      AppConstants.keyThemeMode: prefs.getString(AppConstants.keyThemeMode) ?? AppConstants.defaultTheme,
    };
  }

  Future<void> saveProfile(Map<String, String> data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data.containsKey(AppConstants.keyShopName)) {
      await prefs.setString(AppConstants.keyShopName, data[AppConstants.keyShopName]!);
    }
    if (data.containsKey(AppConstants.keySupplierPhone)) {
      await prefs.setString(AppConstants.keySupplierPhone, data[AppConstants.keySupplierPhone]!);
    }
    if (data.containsKey(AppConstants.keyLanguageCode)) {
      await prefs.setString(AppConstants.keyLanguageCode, data[AppConstants.keyLanguageCode]!);
    }
    if (data.containsKey(AppConstants.keyThemeMode)) {
      await prefs.setString(AppConstants.keyThemeMode, data[AppConstants.keyThemeMode]!);
    }
  }
}
