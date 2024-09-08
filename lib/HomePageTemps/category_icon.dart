import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      this.iconColor});

  final String title;
  final IconData icon;
  final Color? color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(width: 3),
            color: color,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            icon,
            color: iconColor ?? Colors.white,
            size: 30,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}