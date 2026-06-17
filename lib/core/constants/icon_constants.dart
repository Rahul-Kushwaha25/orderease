import 'package:flutter/material.dart';

class IconConfig {
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  const IconConfig({
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });
}

class IconConstants {
  IconConstants._();

  static const String dairy      = 'ic_dairy';
  static const String grain      = 'ic_grain';
  static const String snacks     = 'ic_snacks';
  static const String beverages  = 'ic_beverages';
  static const String spices     = 'ic_spices';
  static const String oil        = 'ic_oil';
  static const String cleaning   = 'ic_cleaning';
  static const String bakery     = 'ic_bakery';
  static const String frozen     = 'ic_frozen';
  static const String personal   = 'ic_personal';
  static const String stationery = 'ic_stationery';
  static const String grocery    = 'ic_grocery';
  static const String meat       = 'ic_meat';
  static const String fruits     = 'ic_fruits';
  static const String vegetables = 'ic_vegetables';

  // Asset path resolver
  static String assetPath(String iconId) => 'assets/icons/$iconId.svg';

  // All icons list (used for icon picker grid)
  static const List<String> all = [
    dairy, grain, snacks, beverages, spices, oil,
    cleaning, bakery, frozen, personal, stationery,
    grocery, meat, fruits, vegetables,
  ];

  static IconConfig getIconConfig(String iconId) {
    switch (iconId) {
      case fruits:
      case vegetables:
        return const IconConfig(
          icon: Icons.spa,
          backgroundColor: Color(0xFFE8F5E9),
          foregroundColor: Color(0xFF2E7D32),
        );
      case dairy:
        return const IconConfig(
          icon: Icons.water_drop,
          backgroundColor: Color(0xFFE8F5E9),
          foregroundColor: Color(0xFF2E7D32),
        );
      case oil:
        return const IconConfig(
          icon: Icons.opacity,
          backgroundColor: Color(0xFFFFF3E0),
          foregroundColor: Color(0xFFE65100),
        );
      case grain:
        return const IconConfig(
          icon: Icons.grain,
          backgroundColor: Color(0xFFFCE4EC),
          foregroundColor: Color(0xFFC2185B),
        );
      case spices:
        return const IconConfig(
          icon: Icons.bolt,
          backgroundColor: Color(0xFFE8F5E9),
          foregroundColor: Color(0xFF2E7D32),
        );
      case snacks:
      case beverages:
        return const IconConfig(
          icon: Icons.flatware,
          backgroundColor: Color(0xFFE0F2F1),
          foregroundColor: Color(0xFF00796B),
        );
      case cleaning:
        return const IconConfig(
          icon: Icons.local_laundry_service,
          backgroundColor: Color(0xFFECEFF1),
          foregroundColor: Color(0xFF607D8B),
        );
      case bakery:
      default:
        return const IconConfig(
          icon: Icons.bakery_dining,
          backgroundColor: Color(0xFFF5F5F5),
          foregroundColor: Color(0xFF616161),
        );
    }
  }
}

