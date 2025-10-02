import 'package:flutter/material.dart';
import 'package:flutter_tastyhub/presentation/screens/auth/register/form_state_register.dart';
import 'package:flutter_tastyhub/presentation/widgets/brand_header.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo
          Image.asset(
            'assets/images/backgroundregister.png',
            fit: BoxFit.cover,
          ),
          // Overlay oscuro
          Container(color: Colors.black.withValues(alpha: 0.7)),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BrandingHeader(),
                SizedBox(height: 140),
                Text(
                  "Hola bienvenido!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                    height: 1.02,
                  ),
                ),
                SizedBox(height: 16),
                FormStateRegister(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
