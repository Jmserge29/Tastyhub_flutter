import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tastyhub/config/providers/providers.dart';
import 'package:flutter_tastyhub/shared/types/app_theme_type.dart';
import 'package:flutter_tastyhub/config/providers/theme/theme_provider.dart';
import 'package:flutter_tastyhub/presentation/screens/core/profile/user_profile_screen.dart';

class UserInformation extends ConsumerWidget {
  const UserInformation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final themeState = ref.watch(themeProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Información del usuario desde Firebase
        Expanded(
          child: currentUserAsync.when(
            data: (user) => Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserProfileScreen(userId: user?.id ?? ''),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: user?.profileImageUrl != null
                        ? NetworkImage(user!.profileImageUrl!)
                        : const NetworkImage(''),
                    child: user?.profileImageUrl == null
                        ? Text(
                            user?.name[0].toUpperCase() ?? 'U',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '¡Hola, ${user?.name ?? 'Chef'}!',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            loading: () => const Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text(
                  'Cargando...',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            error: (error, stack) => const Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.error, color: Colors.red),
                ),
                SizedBox(width: 8),
                Text(
                  '¡Hola, Chef!',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Botón para alternar tema
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: themeState.themeType.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(12),
          ),
          onPressed: () {
            _cycleTheme(ref);
          },
          child: const Icon(Icons.color_lens),
        ),
      ],
    );
  }

  /// Alternar entre los temas en orden cíclico
  void _cycleTheme(WidgetRef ref) {
    final currentTheme = ref.read(themeProvider).themeType;
    final themeNotifier = ref.read(themeProvider.notifier);

    // Obtener el siguiente tema en la lista
    final currentIndex = AppThemeType.values.indexOf(currentTheme);
    final nextIndex = (currentIndex + 1) % AppThemeType.values.length;
    final nextTheme = AppThemeType.values[nextIndex];

    // Cambiar al siguiente tema
    themeNotifier.setThemeType(nextTheme);
  }
}
