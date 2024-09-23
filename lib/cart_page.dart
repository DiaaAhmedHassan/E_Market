import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/cart_product.dart';
import 'package:e_market/details_page.dart';
import 'package:e_market/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _amountController = TextEditingController();

  removeElement(String field, int index) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid);
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await documentReference.get();
    List<dynamic> cart = List.from(snapshot.data()?[field] ?? []);

    cart.removeAt(index);

    await documentReference.update({field: cart});
  }

  updateRequiredAmount(int i, int newAmount) async {
    print("function called");
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid);

    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await documentReference.get();
    List<dynamic> cart = List.from(snapshot.data()?['cart'] ?? []);

    cart[i]['requiredAmount'] = newAmount;

    await documentReference.update({"cart": cart});
  }

  double calculateTotalPrice(List<CartProduct> cartProducts) {
    double totalPrice = 0;
    for (var product in cartProducts) {
      totalPrice += (product.price) * (product.requiredAmount);
    }

    return totalPrice;
  }

  void buyCartProducts(
      List<CartProduct> cartProducts, double totalPrice, BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var user;
    user = MarketUser();
    FirebaseFirestore.instance.collection("Orders").add({
      "userId": userId,
      "products": cartProducts.map((e) => e.toMap()).toList(),
      "totalPrice": totalPrice,
      "date": FieldValue.serverTimestamp(),
      "paymentMethod": "cash"
    });

    for (var product in cartProducts) {
      FirebaseFirestore.instance.collection("products").doc(product.id).update(
          {"availableAmount": FieldValue.increment(-(product.requiredAmount))});
    }

    cartProducts.clear();
    totalPrice = 0;
    user.emptyCart();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: "Successful operation",
      desc:"Your order is on its way and will arrive in a few days. Please be ready to pay with cash when it gets delivered. Thank you for shopping with us!",
      btnOkOnPress: () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("home_page", (route) => false);
      },
    ).show();
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
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              }

              List<dynamic> cartData = snapshot.data?['cart'] ?? [];
              List<CartProduct> cartProducts =
                  cartData.map((data) => CartProduct.fromMap(data)).toList();
              double totalPrice = calculateTotalPrice(cartProducts);
              return cartProducts.isEmpty
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("images/E_comm_logo.png"),
                        const Text(
                          "Your cart is empty",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        )
                      ],
                    ))
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: cartData.length,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              var currentProduct = cartProducts[i];
                              int currentAmount = currentProduct.requiredAmount;
                              _amountController.text = "$currentAmount";
                              return Card(
                                child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ItemDetails(
                                                    data: currentProduct,
                                                    isComingFromCart: true,
                                                    cartAmount: currentAmount,
                                                  )));
                                    },
                                    leading:
                                        Image.network(currentProduct.imageUrl),
                                    title: Text(
                                        "${currentProduct.requiredAmount}X ${currentProduct.title}"),
                                    subtitle: Text(
                                        "${(currentProduct.price) * currentProduct.requiredAmount} \$"),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.more_vert_sharp),
                                      onPressed: () {
                                        _amountController.text =
                                            "$currentAmount";
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                icon: Image.network(
                                                    currentProduct.imageUrl,
                                                    width: 100,
                                                    height: 100),
                                                title:
                                                    Text(currentProduct.title),
                                                content: SizedBox(
                                                  height: 150,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.edit),
                                                          MaterialButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          "Editing required amount"),
                                                                      content: StatefulBuilder(builder: (BuildContext
                                                                              context,
                                                                          StateSetter
                                                                              setState) {
                                                                        return SizedBox(
                                                                          height:
                                                                              150,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  IconButton(
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          if (currentAmount >= 1) {
                                                                                            _amountController.text = "${currentAmount--}";
                                                                                          }
                                                                                        });
                                                                                      },
                                                                                      icon: const Icon(Icons.minimize)),
                                                                                  Expanded(
                                                                                      child: TextField(
                                                                                    textAlign: TextAlign.center,
                                                                                    controller: _amountController,
                                                                                    decoration: const InputDecoration(contentPadding: EdgeInsets.all(5), hintText: "enter new amount", border: OutlineInputBorder(borderSide: BorderSide(width: 1), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                                                                  )),
                                                                                  IconButton(
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          if (currentAmount <= currentProduct.availableAmount) {
                                                                                            currentAmount++;
                                                                                            _amountController.text = "$currentAmount";
                                                                                          }
                                                                                        });
                                                                                      },
                                                                                      icon: const Icon(Icons.add)),
                                                                                ],
                                                                              ),
                                                                              MaterialButton(
                                                                                onPressed: () {
                                                                                  updateRequiredAmount(i, int.parse(_amountController.text));
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                color: Colors.blue,
                                                                                textColor: Colors.white,
                                                                                child: const Text(
                                                                                  "Update",
                                                                                  style: TextStyle(fontSize: 20),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }),
                                                                    );
                                                                  });
                                                            },
                                                            child: const Text(
                                                              "Edit required amount",
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const Divider(),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .remove_shopping_cart_rounded,
                                                            color: Colors.red,
                                                          ),
                                                          MaterialButton(
                                                            onPressed: () {
                                                              AwesomeDialog(
                                                                      context:
                                                                          context,
                                                                      title:
                                                                          "Remove item",
                                                                      desc:
                                                                          "Are you sure you want to delete this item",
                                                                      dialogType:
                                                                          DialogType
                                                                              .question,
                                                                      btnCancelText:
                                                                          "Yes",
                                                                      btnCancelOnPress:
                                                                          () {
                                                                        removeElement(
                                                                            "cart",
                                                                            i);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      btnOkText:
                                                                          "Cancel",
                                                                      btnOkOnPress:
                                                                          () {})
                                                                  .show();
                                                            },
                                                            textColor:
                                                                Colors.red,
                                                            child: const Text(
                                                              "Remove from cart",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    )),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          child: MaterialButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Confirm Order"),
                                      //calculate the total price
                                      content: SizedBox(
                                        height: 100,
                                        child: Column(
                                          children: [
                                            const Text(
                                              "Buy the products in your cart ",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              "$totalPrice\$",
                                              style: const TextStyle(
                                                  fontSize: 35,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          color: Colors.red,
                                          textColor: Colors.white,
                                          child: const Text(
                                            "cancel",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            buyCartProducts(cartProducts,
                                                totalPrice, context);
                                          },
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          child: const Text(
                                            "Buy",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Buy now",
                                  style: TextStyle(fontSize: 24),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.shopping_cart_checkout,
                                  size: 30,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
            }),
      ),
    );
  }
}
