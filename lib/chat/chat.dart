import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/chat/message_text.dart';
import 'package:e_market/chat/messages.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Customer support"),),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("chat_rooms").doc('room_id').collection("messages").orderBy('timestamp').snapshots(), 
      builder: (context, snapshot){
        if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator());
          }
          
          var messages = snapshot.data!.docs;
        return Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    MessageView(isOutGoing: true, message: "Sender message", time: "10:05 AM", date: "22/9/2024",),
                    MessageView(isOutGoing: false,message: "message received", time: "11:05 AM", date: "22/9/2024",),
                  ],
                ),
              ),
            ),
            MessageInputField(
              hintText: "Send message",
              onSend: (){

              },
            )
          ],
        );
      }),
    );
  }
}