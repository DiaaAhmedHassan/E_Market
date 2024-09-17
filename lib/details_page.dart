import 'package:flutter/material.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key, this.product});

   final product;


  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {


  // ignore: prefer_final_fields
  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the initial value
    print(widget.product);
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
                  child: Image.network("${widget.product.imageUrl}"),
                ),
                Positioned(
                  right: 20,
                  top: 20,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
                      color:  Color.fromARGB(142, 0, 0, 0),
                    ),
                    height: 35,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 40, right: 20),
                    child:  Text("Available amount: ${widget.product.availableAmount}", style: const TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 40, top: 20, right: 20),
              child:   Text(
                "${widget.product.title}",
                style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            Container(
                  padding: const EdgeInsets.only(left: 40, top: 20, right: 20),
                  child:   Text("${widget.product.price} \$", style: const TextStyle(color: Color.fromARGB(255, 0, 75, 141), fontSize: 30)),
                ),
            Container(
                padding: const EdgeInsets.only(left: 40, top: 20, right: 20),
                child: Row(
                  children: [
                    ...List.generate(5, (i) {
                       return  widget.product.rating<=i? const Icon(
                        Icons.star_outline,
                        color: Colors.amber,
                        size: 35,
                      ):
                      const Icon(Icons.star, color: Colors.amber, size: 35,);
                    })
                  ],
                )),
            Container(
              padding: const EdgeInsets.only(left: 40, top: 20, right: 20),
              child: Text( 
                "${widget.product.description}",
              ),
            ),
            Column(
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
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.minimize),
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: TextField(
                          controller: _amountController,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: const EdgeInsets.all(5),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(color: Colors.blue)),
                                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue))
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
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
              child: MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {},
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
