import 'package:flutter/material.dart';

class UserInformation extends StatelessWidget {
  const UserInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
            Text('José Serge'),
          ],
        ),
        SizedBox(width: 16),
        ButtonTheme(
          child: ElevatedButton(
            onPressed: () {
              // Acción del botón
            },
            child: Text('Acción'),
          ),
        ),
      ],
    );
  }
}
