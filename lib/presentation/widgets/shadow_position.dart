import 'dart:ui';
import 'package:flutter/material.dart';

class ShadowPosition extends StatelessWidget {
  const ShadowPosition({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -120, // Ajusta para que solo se vea la parte superior
      left: -50,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.bottomCenter,
                stops: [0, 1], // Equivalente a 0% y 100%
                colors: [
                  const Color.fromARGB(255, 0, 0, 0),
                  const Color.fromARGB(9, 13, 4, 4),
                ],
                radius: 1,
                focalRadius: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
