import 'package:flutter/material.dart';

class UserInformation extends StatelessWidget {
  const UserInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                'https://i.pinimg.com/736x/8d/98/09/8d98092817acce47d8a28e93c1deef6f.jpg',
              ),
            ),
            SizedBox(width: 8),
            Text(
              '¡Hola, José Serge!',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 18,
              ),
            ),
          ],
        ),
        SizedBox(width: 16),
        ButtonTheme(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              iconColor: Colors.black,
              backgroundColor: const Color.fromARGB(255, 217, 217, 217),
            ),
            onPressed: () {
              // Acción del botón
            },
            child: Icon(Icons.notifications),
          ),
        ),
      ],
    );
  }
}
