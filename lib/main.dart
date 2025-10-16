import 'package:flutter/material.dart';
import 'package:flutter_tastyhub/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tastyhub/config/firebase_options.dart';
import 'package:flutter_tastyhub/config/theme/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ThemeService().init();
  runApp(ProviderScope(child: App()));
}
