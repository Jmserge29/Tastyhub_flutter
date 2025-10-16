import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_tastyhub/config/theme/theme_service.dart';
import 'package:flutter_tastyhub/config/theme/app_theme_mode.dart';
import 'package:flutter_tastyhub/shared/types/app_theme_type.dart';

/// Provider para inicializar ThemeService
final themeServiceInitProvider = FutureProvider<ThemeService>((ref) async {
  final service = ThemeService();
  await service.init();
  return service;
});

/// Provider del servicio de temas
final themeServiceProvider = Provider<ThemeService>((ref) {
  final asyncService = ref.watch(themeServiceInitProvider);

  return asyncService.when(
    data: (service) => service,
    loading: () => throw Exception('ThemeService aún no está listo'),
    error: (error, stack) => throw error,
  );
});

/// Modelo para el estado del tema
class ThemeState {
  final AppThemeType themeType;
  final AppThemeMode themeMode;

  ThemeState({required this.themeType, required this.themeMode});

  ThemeState copyWith({AppThemeType? themeType, AppThemeMode? themeMode}) {
    return ThemeState(
      themeType: themeType ?? this.themeType,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

/// Notifier para manejar el estado del tema
class ThemeNotifier extends StateNotifier<ThemeState> {
  final ThemeService _themeService;

  ThemeNotifier(this._themeService)
    : super(
        ThemeState(
          themeType: AppThemeType.vintage,
          themeMode: AppThemeMode.system,
        ),
      ) {
    _loadTheme();
  }

  /// Cargar el tema guardado al iniciar
  void _loadTheme() {
    final savedThemeType = _themeService.getThemeType();
    final savedThemeMode = _themeService.getThemeMode();

    state = ThemeState(
      themeType: AppThemeType.fromString(savedThemeType),
      themeMode: AppThemeMode.fromString(savedThemeMode),
    );
  }

  /// Cambiar el tipo de tema
  Future<void> setThemeType(AppThemeType themeType) async {
    state = state.copyWith(themeType: themeType);
    await _themeService.saveThemeType(themeType.key);
  }

  /// Cambiar el modo de tema
  Future<void> setThemeMode(AppThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _themeService.saveThemeMode(mode.key);
  }

  /// Alternar entre light y dark
  Future<void> toggleThemeMode() async {
    if (state.themeMode == AppThemeMode.light) {
      await setThemeMode(AppThemeMode.dark);
    } else {
      await setThemeMode(AppThemeMode.light);
    }
  }
}

/// Provider principal del tema
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  final themeService = ref.watch(themeServiceProvider);
  return ThemeNotifier(themeService);
});
