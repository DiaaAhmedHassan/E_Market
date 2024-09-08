import 'package:flutter/material.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E market"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment.center,
              width: 400,
              height: 250,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 0.5,
                        blurRadius: 20,
                        offset: Offset(0, 10)),
                  ]),
              child: Image.asset("images/1.png"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 40, top: 20, right: 20),
                  child: Text(
                    "Watch",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 40, top: 20, right: 20),
                  child: Text("Avilable amount: 200"),
                ),

                
              ],
            ),
            Container(
                padding: EdgeInsets.only(left: 40, top: 20, right: 20),
                child: Row(
                  children: [
                    ...List.generate(5, (i) {
                      return Icon(
                        Icons.star,
                        color: Colors.blue,
                        size: 35,
                      );
                    })
                  ],
                )),
            Container(
              padding: EdgeInsets.only(left: 40, top: 20, right: 20),
              child: Text( 
                "Discover the perfect blend of sophistication and functionality with our Elegant Men’s Stainless Steel Chronograph Watch.",
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 40, top: 20, right: 20),
                  child: Text(
                    "Amount",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.minimize),
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: TextField(
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: EdgeInsets.all(5),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: Colors.blue)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue))
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add),
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
              margin: EdgeInsets.all(20),
              child: MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {},
                  child: Row(
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
