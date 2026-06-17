import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(AppConstants.keyThemeMode);
    if (savedTheme == 'dark') {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light);
    }
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
      await prefs.setString(AppConstants.keyThemeMode, 'dark');
    } else {
      emit(ThemeMode.light);
      await prefs.setString(AppConstants.keyThemeMode, 'light');
    }
  }
}
