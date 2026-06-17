import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary      = Color(0xFF2E7D32);   // deep green
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color accent       = Color(0xFFFF6F00);   // amber

  // Light theme surfaces
  static const Color surfaceLight     = Color(0xFFF5F5F5);
  static const Color backgroundLight  = Color(0xFFF8F9F7);
  static const Color cardLight        = Color(0xFFFFFFFF);

  // Dark theme surfaces
  static const Color surfaceDark      = Color(0xFF1E1E1E);
  static const Color backgroundDark   = Color(0xFF121212);
  static const Color cardDark         = Color(0xFF2C2C2C);

  // Text
  static const Color textPrimaryLight   = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark    = Color(0xFFEEEEEE);
  static const Color textSecondaryDark  = Color(0xFF9E9E9E);

  // Status
  static const Color error   = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
}
