import 'package:flutter/material.dart';

enum AppThemeType {
  primary,
  summer,
  vintage,
  capital;

  String get name {
    switch (this) {
      case AppThemeType.primary:
        return 'Primary';
      case AppThemeType.summer:
        return 'Summer';
      case AppThemeType.vintage:
        return 'Vintage';
      case AppThemeType.capital:
        return 'Capital';
    }
  }

  String get key {
    return toString().split('.').last;
  }

  /// Color primario del tema
  Color get primaryColor {
    switch (this) {
      case AppThemeType.primary:
        return const Color(0xFF6200EE); // Púrpura
      case AppThemeType.summer:
        return const Color(0xFFA8E6CF); // Verde claro pastel
      case AppThemeType.vintage:
        return const Color.fromARGB(255, 145, 93, 86); // Terracota
      case AppThemeType.capital:
        return const Color(0xFF64B5F6); // Azul clarito
    }
  }

  /// Color complementario del tema
  Color get accentColor {
    switch (this) {
      case AppThemeType.primary:
        return const Color(0xFF03DAC6); // Cyan
      case AppThemeType.summer:
        return const Color(0xFFFFB3BA); // Rosado claro pastel
      case AppThemeType.vintage:
        return const Color.fromRGBO(67, 39, 32, 1); // Marrón oscuro
      case AppThemeType.capital:
        return const Color(0xFF42A5F5); // Azul un poco más subido
    }
  }

  /// Color primario para modo oscuro
  Color get primaryColorDark {
    switch (this) {
      case AppThemeType.primary:
        return const Color(0xFFBB86FC);
      case AppThemeType.summer:
        return const Color(0xFF80D8B0);
      case AppThemeType.vintage:
        return const Color.fromARGB(255, 165, 113, 106);
      case AppThemeType.capital:
        return const Color(0xFF90CAF9);
    }
  }

  /// Color complementario para modo oscuro
  Color get accentColorDark {
    switch (this) {
      case AppThemeType.primary:
        return const Color(0xFF018786);
      case AppThemeType.summer:
        return const Color(0xFFFFCCD5); // Rosado más claro
      case AppThemeType.vintage:
        return const Color.fromRGBO(97, 59, 52, 1); // Marrón menos oscuro
      case AppThemeType.capital:
        return const Color(0xFF64B5F6);
    }
  }

  static AppThemeType fromString(String value) {
    switch (value) {
      case 'primary':
        return AppThemeType.primary;
      case 'summer':
        return AppThemeType.summer;
      case 'vintage':
        return AppThemeType.vintage;
      case 'capital':
        return AppThemeType.capital;
      default:
        return AppThemeType.vintage; // Default
    }
  }
}
