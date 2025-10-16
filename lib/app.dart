import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tastyhub/config/providers/theme/theme_provider.dart';
import 'package:flutter_tastyhub/presentation/screens/auth/wrapper/auth_wrapper.dart';
import 'package:flutter_tastyhub/config/theme/app_themes.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeServiceAsync = ref.watch(themeServiceInitProvider);

    return themeServiceAsync.when(
      // Mientras carga
      loading: () => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      // Si hay error
      error: (error, stack) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: Text('Error: $error'))),
      ),
      // Cuando está listo
      data: (_) {
        final themeState = ref.watch(themeProvider);

        return MaterialApp(
          title: 'TastyHub',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.getLightTheme(themeState.themeType),
          darkTheme: AppThemes.getDarkTheme(themeState.themeType),
          themeMode: themeState.themeMode.toThemeMode(),
          home: const AuthWrapper(),
        );
      },
    );
  }
}
