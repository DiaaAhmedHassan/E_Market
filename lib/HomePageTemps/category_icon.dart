import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
   const CategoryIcon(
      {super.key,
      required this.title,
      required this.icon, 
      required this.isSelected,
      required this.onTap});

  final String title;
  final Image icon;
  final bool isSelected;
  final VoidCallback onTap;

  


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            color: isSelected? Colors.blue[50]: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(icon:
          icon,
           onPressed: (){
            onTap();
           },),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

 
}