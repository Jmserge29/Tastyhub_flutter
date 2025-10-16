// lib/services/theme_service.dart
import 'package:shared_preferences/shared_preferences.dart';

/// Keys para SharedPreferences
enum PreferenceKey {
  themeType,
  themeMode,
  language,
  firstTime;

  String get key => toString().split('.').last;
}

class ThemeService {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception(
        'ThemeService no ha sido inicializado. Llama a init() primero.',
      );
    }
    return _prefs!;
  }

  // ========== THEME TYPE ==========

  Future<bool> saveThemeType(String themeType) async {
    return await prefs.setString(PreferenceKey.themeType.key, themeType);
  }

  String getThemeType() {
    return prefs.getString(PreferenceKey.themeType.key) ?? 'vintage';
  }

  // ========== THEME MODE ==========

  Future<bool> saveThemeMode(String themeMode) async {
    return await prefs.setString(PreferenceKey.themeMode.key, themeMode);
  }

  String getThemeMode() {
    return prefs.getString(PreferenceKey.themeMode.key) ?? 'system';
  }

  bool isDarkMode() {
    return getThemeMode() == 'dark';
  }

  // ========== LANGUAGE ==========

  Future<bool> saveLanguage(String languageCode) async {
    return await prefs.setString(PreferenceKey.language.key, languageCode);
  }

  String getLanguage() {
    return prefs.getString(PreferenceKey.language.key) ?? 'es';
  }

  // ========== FIRST TIME ==========

  bool isFirstTime() {
    return prefs.getBool(PreferenceKey.firstTime.key) ?? true;
  }

  Future<bool> setNotFirstTime() async {
    return await prefs.setBool(PreferenceKey.firstTime.key, false);
  }

  // ========== UTILITIES ==========

  Future<bool> clearAll() async {
    return await prefs.clear();
  }

  Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  // ========== MÉTODOS GENÉRICOS ==========

  Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  String? getString(String key) {
    return prefs.getString(key);
  }

  Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return prefs.getInt(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }
}
