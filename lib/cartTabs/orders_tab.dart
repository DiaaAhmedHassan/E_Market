import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/cart_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}


class _OrdersTabState extends State<OrdersTab> {
  List orders = [];

  getOrdersData()async{
    String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Orders').where('userId', isEqualTo: userId).get();
    orders.addAll(snapshot.docs);
    print(orders);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOrdersData();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, i){
        Timestamp timestamp = orders[i]['date'];
        DateTime dateTime = timestamp.toDate();
        String date = DateFormat("dd/MM/yyyy").format(dateTime);
        List orderProducts;
        orderProducts = orders[i]['products'].map((e) => CartProduct.fromMap(e)).toList();
        bool isOrderCanBeCanceled = orders[i]['canBeCanceled'];
        return Container(
          margin:const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            boxShadow: const[BoxShadow(offset: Offset(5, 5), color: Colors.blueGrey, blurRadius: 10)],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order date: $date", style:const TextStyle(fontSize: 16),),
              const Text("order products", style: TextStyle(fontSize: 20),),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: ListView.builder(
                    itemCount: orderProducts.length,
                  shrinkWrap: true,
                  itemBuilder: (context, j){
                    return ListTile(
                      leading: Image.network(orderProducts[j].imageUrl),
                      title: Text( "${orderProducts[j].requiredAmount}X ${orderProducts[j].title}", style: TextStyle(fontSize: 18),),
                      trailing: Text("${orderProducts[j].requiredAmount * orderProducts[j].price} \$", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),),
                    );
                  },
                  
                ),
                )),
              Text("Total price: ${orders[i]['totalPrice']} \$", style: TextStyle(fontSize: 18),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Payment method: ${orders[i]['paymentMethod']}", style: TextStyle(fontSize: 18),),
                  MaterialButton(
                    onPressed:isOrderCanBeCanceled? (){
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.question,
                        title: "Cancel order", 
                        desc: "Are you sure you want to cancel this order",
                        btnOkOnPress: (){
                          FirebaseFirestore.instance.collection("Orders").doc(orders[i].id).delete();
                      setState(() {
                        orders.removeAt(i);
                      });
                        }, 
                        btnCancelOnPress: (){
                          Navigator.of(context).pop();
                        }
                      ).show();
                      
                    }: null,
                    disabledColor: Colors.grey,
                    
                   child: Text("cancel order", style: TextStyle(fontSize: 16),),
                   color: Colors.red,
                   textColor: Colors.white,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  )
                ],
              )
            ]
          ),
        );
      });
  }
}