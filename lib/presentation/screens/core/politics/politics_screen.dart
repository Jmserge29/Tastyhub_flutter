import 'package:flutter/material.dart';

class PoliticsScreen extends StatelessWidget {
  const PoliticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Title
                const Text(
                  'Políticas de\nTastyHub',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 20),

                // Description
                const Text(
                  'Bienvenido a TastyHub, una comunidad creada para compartir y descubrir recetas, tips de cocina y experiencias gastronómicas.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Antes de continuar, te invitamos a leer nuestras políticas, diseñadas para mantener un espacio seguro y agradable para todos.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 25),

                // CONTENIDO COMPARTIDO section
                const Text(
                  'CONTENIDO COMPARTIDO',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 53, 14, 14),
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 15),

                _buildPolicyItem(
                  icon: Icons.front_hand_outlined,
                  iconColor: const Color(0xFF8B1538),
                  text:
                      'Eres responsable del contenido que publiques (recetas, imágenes, comentarios).',
                ),

                const SizedBox(height: 12),

                _buildPolicyItem(
                  icon: Icons.front_hand_outlined,
                  iconColor: const Color(0xFF8B1538),
                  text:
                      'Evita subir material ofensivo, violento o que infrinja derechos de autor.',
                ),

                const SizedBox(height: 12),

                _buildPolicyItem(
                  icon: Icons.front_hand_outlined,
                  iconColor: const Color(0xFF8B1538),
                  text:
                      'Las recetas e imágenes compartidas deben ser de tu autoría o contar con los permisos necesarios.',
                ),

                const SizedBox(height: 25),

                // PRIVACIDAD Y SEGURIDAD section
                const Text(
                  'PRIVACIDAD Y SEGURIDAD',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 53, 14, 14),
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 15),

                _buildPolicyItem(
                  icon: Icons.info_outline,
                  iconColor: const Color(0xFF8B1538),
                  text:
                      'Respetamos tu información personal y solo será utilizada para mejorar tu experiencia dentro de la app.',
                ),

                const SizedBox(height: 12),

                _buildPolicyItem(
                  icon: Icons.info_outline,
                  iconColor: const Color(0xFF8B1538),
                  text:
                      'Nunca compartiremos tus datos con terceros sin tu consentimiento.',
                ),

                const SizedBox(height: 12),

                _buildPolicyItem(
                  icon: Icons.info_outline,
                  iconColor: const Color(0xFF8B1538),
                  text:
                      'Recuerda no publicar información sensible en tu perfil o recetas.',
                ),

                const SizedBox(height: 25),

                // Warning box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF8B1538),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_outlined,
                        color: const Color(0xFF8B1538),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No se permite el uso de la app con fines fraudulentos, inapropiados o que vayan en contra de las leyes vigentes.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyItem({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
