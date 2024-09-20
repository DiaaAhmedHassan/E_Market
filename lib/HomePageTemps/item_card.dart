import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.itemName, required this.price, required this.rating, required this.imagePath});

  final String imagePath;
  final String itemName;
  final double price;
  final int rating;

  @override
  Widget build(BuildContext context) {
    return Container(
    height: 200,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(10),
          ),
      clipBehavior: Clip.hardEdge,
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(imagePath, width: 100, height: 95, fit: BoxFit.fill,),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              color: Colors.grey[100],
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(itemName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20), overflow: TextOverflow.ellipsis,)),
                  Flexible(child: Text("$price \$",)),

                  Row(children: [
                    ...List.generate(5, (i){
                      return Icon(i < rating? Icons.star: Icons.star_border, color: Colors.blue, size: 18,);
                    
                  })],)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
