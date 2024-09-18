import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/cart_product.dart';
import 'package:e_market/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartProduct> cartProducts = [];

  getUserCart() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    List products = snapshot['cart'];
    products.forEach((product) => cartProducts.add(CartProduct(
        title: product['title'],
        price: (product['price'] as num).toDouble(),
        description: product['description'],
        rating: product['rating'],
        availableAmount: product['availableAmount'],
        imageUrl: product['imageUrl'],
        category: product['category'], 
        requiredAmount: product['requiredAmount'])));

    setState(() {});
  }

  @override
  void initState() {
    print(cartProducts);
    getUserCart();
    print(cartProducts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
        title: const Row(
          children: [
            Text('Cart'),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.shopping_cart_outlined,
              size: 30,
              color: Colors.blue,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartProducts.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      leading: Image.network(cartProducts[i].imageUrl),
                      title: Text("${cartProducts[i].requiredAmount}X ${cartProducts[i].title}"),
                      subtitle: Text("${(cartProducts[i].price)*cartProducts[i].availableAmount} \$"),
                      trailing: MaterialButton(
                        onPressed: () {},
                        child: Text("Remove"),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: MaterialButton(
                onPressed: () {},
                child: Text(
                  "Buy now",
                  style: TextStyle(fontSize: 24),
                ),
                color: Colors.blue,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
