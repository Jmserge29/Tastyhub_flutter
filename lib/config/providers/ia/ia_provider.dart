import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tastyhub/config/ia/ia_service.dart';

final aiServiceProvider = Provider<AIService>((ref) {
  return AIService();
});
