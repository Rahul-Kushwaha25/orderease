import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._dataSource);

  final ProfileLocalDataSource _dataSource;

  @override
  Future<ProfileEntity> getProfile() async {
    final Map<String, String> data = await _dataSource.fetchProfile();
    return ProfileEntity(
      shopName: data[AppConstants.keyShopName] ?? 'My Shop',
      supplierPhone: data[AppConstants.keySupplierPhone] ?? '',
      languageCode: data[AppConstants.keyLanguageCode] ?? AppConstants.defaultLanguage,
      themeMode: data[AppConstants.keyThemeMode] ?? AppConstants.defaultTheme,
    );
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    await _dataSource.saveProfile({
      AppConstants.keyShopName: profile.shopName,
      AppConstants.keySupplierPhone: profile.supplierPhone,
      AppConstants.keyLanguageCode: profile.languageCode,
      AppConstants.keyThemeMode: profile.themeMode,
    });
  }
}
