import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(100),

                  ),
                  child: Image.asset("images/avatar.png"),
                ),
                
              ),
              const SizedBox(height: 10,),
              const Text("Email", style: TextStyle(fontSize: 24),),
              const SizedBox(height: 5,),
              ProfileText(hint: "email",enabled: false,),
              const SizedBox(height: 20,),
              const Text("User name", style: TextStyle(fontSize: 24),),
              const SizedBox(height: 5,),
              Row(
                children: [
                  Flexible(child: ProfileText(hint: "your name here",enabled: false)),
                  const SizedBox(width: 10,),
                  IconButton(onPressed: (){}, icon: Icon(Icons.edit))
                ],
              ),
              const SizedBox(height: 20,),
              const Text("phone number", style: TextStyle(fontSize: 24),),
              const SizedBox(height: 5,),
              Row(
                children: [
                  Flexible(child: ProfileText(hint: "phone number",enabled: false)),
                  const SizedBox(width: 10,),
                  IconButton(onPressed: (){}, icon: Icon(Icons.edit))
                ],
              ),
              const SizedBox(height: 30,),

              SizedBox(
                width: double.infinity,
                child: MaterialButton(onPressed: (){},
                 color: Colors.blue, textColor: Colors.white, 
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child:const Text("Update", style: TextStyle(fontSize: 20),),)),
              const SizedBox(height: 30,),

              SizedBox(
                width: double.infinity,
                child: MaterialButton(onPressed: (){},
                 color: Colors.red, textColor: Colors.white, 
                child:const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text("Delete my account", style: TextStyle(fontSize: 20),),
                     SizedBox(width: 10,),
                     Icon(Icons.delete)
                  ],
                ),))
            ],
          ),),
      ),
    );
  }
}

class ProfileText extends StatelessWidget{
   ProfileText({super.key, this.controller, this.hint, this.enabled, this.suffixIcon});

  TextEditingController? controller = TextEditingController();
  final String? hint;
  bool? enabled = true;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      
                decoration: InputDecoration(
                  hintText: "$hint", 
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(5)),
                  contentPadding:const EdgeInsets.all(10),
                ),
              );
  }

}
