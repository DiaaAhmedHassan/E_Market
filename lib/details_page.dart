import 'package:e_market/cart_product.dart';
import 'package:e_market/user.dart';
import 'package:flutter/material.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key, this.data, required this.isComingFromCart, this.cartAmount});

  final data;
  final bool isComingFromCart;
  final int? cartAmount;

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  // ignore: prefer_final_fields
  TextEditingController _amountController = TextEditingController();

  int amount = 1;

  var product;
  addCurrentProductToCart(CartProduct product) {
    var user = MarketUser();
    user.addProductToCart(product);
  }

  @override
  void initState() {
    super.initState();
    print(widget.data.title);
    print("init state details page");
    _amountController.text = '1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E market"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  width: 400,
                  height: 250,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.5,
                            blurRadius: 20,
                            offset: Offset(0, 10)),
                      ]),
                  child: Image.network("${widget.data.imageUrl}"),
                ),
                Positioned(
                  right: 20,
                  top: 20,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                      color: Color.fromARGB(142, 0, 0, 0),
                    ),
                    height: 35,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 40, right: 20),
                    child: Text(
                      "Available amount: ${widget.data.availableAmount}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 40, top: 20, right: 20),
              child: Text(
                "${widget.data.title}",
                style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 40, top: 20, right: 20),
              child: Text("${widget.data.price} \$",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 75, 141), fontSize: 30)),
            ),
            Container(
                padding: const EdgeInsets.only(left: 40, top: 20, right: 20),
                child: Row(
                  children: [
                    ...List.generate(5, (i) {
                      return widget.data.rating <= i
                          ? const Icon(
                              Icons.star_outline,
                              color: Colors.amber,
                              size: 35,
                            )
                          : const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 35,
                            );
                    })
                  ],
                )),
            Container(
              padding: const EdgeInsets.only(left: 40, top: 20, right: 20),
              child: Text(
                "${widget.data.description}",
              ),
            ),
           widget.isComingFromCart?
            Container(
              padding:const EdgeInsets.all(10),
              child: Row(children: [Text("Required amount: ${widget.cartAmount}", style: const TextStyle(fontSize: 20,),)],))
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 40, top: 20, right: 20),
                  child: const Text(
                    "Amount",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child:Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (amount > 1) {
                            amount--;
                            setState(() {
                              _amountController.text = "$amount";
                            });
                          }
                        },
                        icon: const Icon(Icons.minimize),
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: TextField(
                          controller: _amountController,
                          onSubmitted: (val) {
                            int intVal = int.parse(val);
                            if (intVal > widget.data.availableAmount) {
                              setState(() {
                                _amountController.text =
                                    "${widget.data.availableAmount}";
                              });
                            } else if (intVal < 1) {
                              setState(() {
                                _amountController.text = "1";
                              });
                            }
                          },
                          onChanged: (val) {
                            if (val.isNotEmpty) {
                              int intVal = int.parse(val);
                              if (intVal > widget.data.availableAmount) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("invalid quantity")));
                                amount = widget.data.availableAmount;
                              } else if (intVal < 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("invalid quantity")));
                                amount = 1;
                              } else {
                                amount = intVal;
                              }
                            }
                          },
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: const EdgeInsets.all(5),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      const BorderSide(color: Colors.blue)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue))),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (amount < widget.data.availableAmount) amount++;
                          setState(() {
                            _amountController.text = "$amount";
                          });
                        },
                        icon: const Icon(Icons.add),
                        color: Colors.blue,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: 400,
              height: 50,
              margin: const EdgeInsets.all(20),
              child:widget.isComingFromCart?
                const SizedBox()
               :MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                        print("Function called");

                    product = CartProduct(
                        id: widget.data.id,
                        title: widget.data.title,
                        price: widget.data.price,
                        description: widget.data.description,
                        rating: widget.data.rating,
                        availableAmount: widget.data.availableAmount,
                        imageUrl: widget.data.imageUrl,
                        category: widget.data.category,
                        requiredAmount: amount);
                        print("Conversion done");
                    addCurrentProductToCart(product);
                    print("product added");

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Product added to you cart succefully")));
                    Navigator.of(context).pushReplacementNamed("cart_page");
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Add to cart", style: TextStyle(fontSize: 20)),
                      SizedBox(width: 10),
                      Icon(
                        Icons.add_shopping_cart_rounded,
                        size: 30,
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
