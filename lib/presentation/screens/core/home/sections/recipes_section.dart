import 'package:flutter/material.dart';

class RecipesSection extends StatelessWidget {
  const RecipesSection({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Row(
          children: [
            Container(
              width: 100,
              height: 100,
              color: Colors.grey,
              margin: EdgeInsets.all(8),
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.grey,
              margin: EdgeInsets.all(8),
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.grey,
              margin: EdgeInsets.all(8),
            ),
          ],
        ),
      ],
    );
  }
}
