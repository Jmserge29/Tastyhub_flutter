import 'package:flutter/material.dart';

class BrandingHeader extends StatelessWidget {
  const BrandingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Center(
          child: Text(
            "TASTYHUB",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              fontFamily: 'Inter',
              shadows: [
                Shadow(
                  offset: Offset(0, 4), // X:0, Y:4
                  blurRadius: 20, // Blur: 20
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
