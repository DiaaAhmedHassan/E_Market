import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        leading: Icon(Icons.shopping_cart_outlined, size: 30, color: Colors.blue,),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Card(
                  child: ListTile(
                  leading: Image.asset("images/4.png"),
                  title: Text("Product 1"),
                  subtitle: Text("\$10"),
                  trailing: MaterialButton(onPressed: (){}, child: Text("Remove"),),
                ),)
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: MaterialButton(onPressed: (){}, 
            child: Text("Buy now", style: TextStyle(fontSize: 24),), 
            color: Colors.blue,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
          )
          
        ],
      ),
    );
  }
}