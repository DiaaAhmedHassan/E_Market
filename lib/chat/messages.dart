import 'package:flutter/material.dart';

class MessageView extends StatelessWidget {
   MessageView({super.key,required this.isOutGoing,  this.message,  this.time, this.date});

  bool isOutGoing = true;
  String?date;
   String? message;
   String? time;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:isOutGoing? CrossAxisAlignment.end: CrossAxisAlignment.start,
      children: [
         Text("$date"),
        Container(
          padding: const EdgeInsets.all(15),
          constraints:const BoxConstraints(maxWidth: 200),
          decoration:  BoxDecoration(
            color:isOutGoing? Colors.blue: Colors.white,
            boxShadow:const [BoxShadow(color: Colors.blueGrey, blurRadius: 20, offset: Offset(10, 10))],
            borderRadius: 
            isOutGoing?
             const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)):
             const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20) )
          ),
          child:  Column(
            crossAxisAlignment:isOutGoing? CrossAxisAlignment.end: CrossAxisAlignment.start,
            children: [
              Text("$message", style: TextStyle(color:isOutGoing? Colors.white: Colors.black, fontSize: 18), ),
              const SizedBox(height: 5,),
              Text("$time", textAlign:isOutGoing? TextAlign.end: TextAlign.start, style: TextStyle(color: isOutGoing? Colors.white: Colors.black),),
            ],
          )),
      ],
    );
  }
}