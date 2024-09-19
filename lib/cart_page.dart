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

  removeElement(String field, int index) async{
   DocumentReference<Map<String, dynamic>> documentReference =await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);
   DocumentSnapshot<Map<String, dynamic>> snapshot =await documentReference.get();
   List<dynamic> cart = List.from(snapshot.data()?[field]??[]);

   cart.removeAt(index);


   await documentReference.update({field: cart});

   
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.blue),
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
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator(color: Colors.blue,),);
                  }

                  List<dynamic> cartData = snapshot.data?['cart']??[];
                  List<CartProduct> cartProducts = cartData.map((data) => CartProduct.fromMap(data)).toList();
                  
                return cartProducts.isEmpty?
                 Center(child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/E_comm_logo.png"),
                      Text("Your cart is empty", style: TextStyle(fontSize: 30, fontWeight:FontWeight.bold, color: Colors.blue),)
                    ],
                  ))
                 :ListView.builder(
                  itemCount: cartData.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    var currentProduct = cartProducts[i];
                    return Card(
                      child: ListTile(
                        leading:Image.network(currentProduct.imageUrl),
                        title: Text("${currentProduct.requiredAmount}X ${currentProduct.title}"),
                        subtitle: Text("${(currentProduct.price)*currentProduct.requiredAmount} \$"),
                        trailing: MaterialButton(
                          onPressed: () {
                            removeElement("cart", i);
                          },
                          child: const Text("Remove"),
                        ),
                      ),
                    );
                  },
                );}
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: MaterialButton(
                onPressed: () {},
                color: Colors.blue,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Buy now",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
