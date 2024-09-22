import 'package:flutter/material.dart';

class MessageInputField extends StatefulWidget {
  MessageInputField({super.key, this.messageController, this.onSend, this.hintText});

 TextEditingController? messageController = TextEditingController();
  VoidCallback? onSend;
  String? hintText;

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {

  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.all(10),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: widget.messageController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              filled: true,
              fillColor: Colors.grey[50],
              hintText: "${widget.hintText}",
              hintStyle:const TextStyle(color: Colors.blue),
              focusedBorder: OutlineInputBorder(borderSide:const BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(30)),
              focusColor: Colors.blue,
            ),
            
        ),),
        IconButton(onPressed: widget.onSend , icon:const Icon(Icons.send, color: Colors.blue,), iconSize: 35,),
      ],),
    );
  }
}