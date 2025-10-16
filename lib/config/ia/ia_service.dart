import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  static const String _apiKey = 'AIzaSyB-A4g4091K2IZYlECf4nVfEWwWE3q7w3o';
  late final GenerativeModel _model;

  AIService() {
    _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
  }

  Future<String> improveRecipeDescription({
    required String description,
    String? title,
    List<String>? ingredients,
  }) async {
    try {
      final prompt =
          '''
Eres un experto chef y escritor culinario. Mejora la siguiente descripción de una receta haciéndola más atractiva, apetitosa y profesional. 
Mantén el mismo idioma (español) y mantén la esencia original, pero hazla más descriptiva y deliciosa.
No agregues información que no esté en la descripción original.
Máximo 3-4 oraciones.

${title != null ? 'Título de la receta: $title\n' : ''}
${ingredients != null && ingredients.isNotEmpty ? 'Ingredientes principales: ${ingredients.take(5).join(", ")}\n' : ''}

Descripción original:
"$description"

Descripción mejorada (solo escribe la descripción mejorada, sin explicaciones adicionales):
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('No se recibió respuesta de la IA');
      }

      String improvedText = response.text!.trim();
      if (improvedText.startsWith('"') && improvedText.endsWith('"')) {
        improvedText = improvedText.substring(1, improvedText.length - 1);
      }

      return improvedText;
    } catch (e) {
      throw Exception('Error al mejorar la descripción: $e');
    }
  }
}
