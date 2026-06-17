import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.shopName,
    required this.supplierPhone,
    required this.languageCode,
    required this.themeMode,
  });

  final String shopName;
  final String supplierPhone;
  final String languageCode;
  final String themeMode;

  @override
  List<Object?> get props => [shopName, supplierPhone, languageCode, themeMode];
}
