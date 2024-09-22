import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/chat/message_text.dart';
import 'package:e_market/chat/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  TextEditingController _messageController = TextEditingController();
  bool _isDocumentExist = false;

  void sendMessage(){
    String userId = FirebaseAuth.instance.currentUser!.uid;
    if(_messageController.text.isNotEmpty){
    DocumentReference ref =   FirebaseFirestore.instance.collection("chat_rooms").doc(userId).collection("support").doc();
    ref.set(
      {"sender id": userId,
      "message": _messageController.text,
      "timestamp": FieldValue.serverTimestamp(),
      });
      _messageController.clear();
     checkDocumentExists();
    }
  }

  checkDocumentExists()async{
    String userId = FirebaseAuth.instance.currentUser!.uid;
   final doc =await FirebaseFirestore.instance.collection("chat_rooms").doc(userId).collection("support").limit(1).get();


    setState(() {
     _isDocumentExist = doc.docs.isNotEmpty;
    });

  }

  @override
  void initState() {
    super.initState();
    checkDocumentExists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Customer support"),),
      body:_isDocumentExist? StreamBuilder(
        stream: FirebaseFirestore.instance.collection("chat_rooms").doc(FirebaseAuth.instance.currentUser!.uid).collection("support").orderBy('timestamp').snapshots(), 
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
                child: ListView.builder(
                  itemCount: messages.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i){
                    bool isMessageOutGoing = FirebaseAuth.instance.currentUser!.uid == messages[i]['sender id'];
                    Timestamp? timestamp = messages[i]['timestamp'];
                    String formattedDate = '';
                    String formattedTime = '';
                    if(timestamp != null){
                    DateTime dateTime = timestamp.toDate();
                     formattedDate= DateFormat('dd/MM/yyyy').format(dateTime);
                     formattedTime = DateFormat('hh:mm a').format(dateTime);
                    }
                    return MessageView(
                      isOutGoing: isMessageOutGoing, 
                      message: messages[i]['message'],
                      date: formattedDate,
                      time: formattedTime,
                      );
                  },
                ),
              ),
            ),
            MessageInputField(
              messageController: _messageController,
              hintText: "Send message",
              onSend: (){
                sendMessage();
              },
            )
          ],
        );
      }):
      Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Center(child: Text("No messages yet"))),
          MessageInputField(
              messageController: _messageController,
              hintText: "Send message",
              onSend: (){
                sendMessage();
              },)
        ],
      ),),
    );
  }
}