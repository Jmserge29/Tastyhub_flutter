import 'package:flutter/material.dart';
import 'package:flutter_tastyhub/presentation/screens/auth/login/login_screen.dart';
import 'package:flutter_tastyhub/presentation/shared/brand_header.dart';
import 'package:flutter_tastyhub/presentation/shared/custom_button.dart';
import 'package:flutter_tastyhub/presentation/shared/shadow_position.dart';

class Presentation extends StatelessWidget {
  const Presentation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo
          Image.asset(
            'assets/images/presentation_image.png',
            fit: BoxFit.cover,
          ),
          ShadowPosition(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandingHeader(),
                const Spacer(),
                Text(
                  "Cocina\nDisfruta\ny cuídate!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 62,
                    fontWeight: FontWeight.w900,
                    height: 1.02,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Deliciosas recetas para todos los gustos y niveles "
                  "de habilidad. Fácil, divertido y saludable.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 30),
                // Botón estilo personalizado
                CustomButton(
                  text: "Comenzar ahora",
                  rightIcon: Icons.arrow_forward,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
