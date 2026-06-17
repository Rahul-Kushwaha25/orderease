import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale(AppConstants.defaultLanguage));

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString(AppConstants.keyLanguageCode) ?? AppConstants.defaultLanguage;
    emit(Locale(savedLang));
  }

  Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyLanguageCode, languageCode);
    emit(Locale(languageCode));
  }
}
