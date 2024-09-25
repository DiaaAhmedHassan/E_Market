import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool isUsernameEnabled = false;
  bool isPhoneEnabled = false;

  File? file;
  String? photoUrl;

  var user;

  Future<void> _handelImageUpload(XFile pickedImage) async{
    file = File(pickedImage.path);
    if(file != null){
      var imageName = path.basename(pickedImage.path);
      var imageRef = FirebaseStorage.instance.ref(imageName);
      await imageRef.putFile(file!);
      photoUrl = await imageRef.getDownloadURL();
    }
  }
  getImageFromCamera()async{
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedImage =await imagePicker.pickImage(source: ImageSource.camera);
    if(pickedImage != null) {
      _handelImageUpload(pickedImage);
    }
    setState(() {
      
    });
  }

  getImageFromGallery()async{
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedImage != null) {
      _handelImageUpload(pickedImage);
    }
    setState(() {
      
    });
  }

  updateUserProfile(String? newImage, String? newName, String? newPhoneNumber){ 
    user = MarketUser();
    user.updateProfile(newImage, newName, newPhoneNumber);
  }



  void deleteUserAccount(user, BuildContext context) {
    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).delete();
    FirebaseFirestore.instance.collection("chat_rooms").doc(FirebaseAuth.instance.currentUser!.uid).delete();
    print("firestore data deleted");
    FirebaseAuth.instance.currentUser!.delete();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.hasError){
          return const Text("an error occurred ...");
        }

        if(snapshot.hasData && !snapshot.data!.exists){
          return const Text("Data doesn't exist");
        }

        if(snapshot.connectionState == ConnectionState.done){
          MarketUser user;
          Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
          user = MarketUser(email: FirebaseAuth.instance.currentUser!.email, imageUrl: userData['imageUrl'], name: userData['username'], phoneNumber: userData['PhoneNumber']);
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
                    child: Column(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(100),
                        
                          ),
                          child:file == null? Image.network("${user.imageUrl}", width: 100, height: 100,fit: BoxFit.cover,):
                          photoUrl != null?
                          Image.network("${user.imageUrl}", width: 100, height: 100,fit: BoxFit.cover,):
                          Image.file(file!, width: 100, height: 100, fit: BoxFit.cover,)
                        ),
                        MaterialButton(onPressed: (){
                          showModalBottomSheet(
                            context: context,
                             builder: (builder){
                            return Container(
                                  height: 150.0,
                                  color: Colors.transparent, 
                                  child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(10.0),
                                              topRight:
                                                  Radius.circular(10.0))),
                                      child:  Center(
                                        child:
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Text("Upload a photo via", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                                                const SizedBox(height: 30,),                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                  Column(
                                                    children: [
                                                      IconButton(onPressed: (){
                                                        getImageFromGallery();
                                                      }, icon: const Icon(Icons.image, size: 40, color: Colors.blue,)),
                                                      const Text("Gallery",)
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      IconButton(onPressed: (){
                                                        getImageFromCamera();
                                                      }, icon: const Icon(Icons.camera_alt, size: 40, color: Colors.blue,)),
                                                      const Text("Capture a photo",)
                                                
                                                    ],
                                                  ),
                                                ],),
                                              ],
                                            ),
                                      )));
                          });
                        }, child:const Text("Change", style: TextStyle(fontSize: 20),),)
                      ],
                    ),
                    
                  ),
                  const SizedBox(height: 10,),
                  const Text("Email", style: TextStyle(fontSize: 24),),
                  const SizedBox(height: 5,),
                  ProfileText(
                    hint: "${user.email}",enabled: false,),
                  const SizedBox(height: 20,),
                  const Text("User name", style: TextStyle(fontSize: 24),),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      Flexible(child: ProfileText(
                        controller: _usernameController,
                        hint: "${user.name}",
                        enabled: isUsernameEnabled)),
                      const SizedBox(width: 10,),
                      IconButton(onPressed: (){
                        setState(() {
                          isUsernameEnabled = !isUsernameEnabled;
                        });
                      }, icon: const Icon(Icons.edit))
                    ],
                  ),
                  const SizedBox(height: 20,),
                  const Text("Phone number", style: TextStyle(fontSize: 24),),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      Flexible(child: ProfileText(
                        controller: _phoneNumberController,
                        hint: "${user.phoneNumber}",
                        enabled: isPhoneEnabled)),
                      const SizedBox(width: 10,),
                      IconButton(onPressed: (){
                        setState(() {
                          isPhoneEnabled = !isPhoneEnabled;
                        });
                      }, icon: const Icon(Icons.edit))
                    ],
                  ),
                  const SizedBox(height: 30,),
        
                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(onPressed: (){
                      print("image url: $photoUrl");
                      updateUserProfile(photoUrl??user.imageUrl, _usernameController.text == ""?user.name:_usernameController.text, _phoneNumberController.text == ""? user.phoneNumber: _phoneNumberController.text);
                    },
                     color: Colors.blue, textColor: Colors.white, 
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child:const Text("Update", style: TextStyle(fontSize: 20),),)),
                  const SizedBox(height: 30,),
        
                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(onPressed: (){

                      AwesomeDialog(
                        context: context, 
                        dialogType: DialogType.warning,
                        title: "Delete your account",
                        desc: "Are yous sure you want you to delete your account ?",
                        btnCancelColor: Colors.red,
                        
                        btnCancelText: "Ok",
                        btnCancelOnPress: () {
                           int timerCount = 10;
                           bool isCanceled = false;

                           Timer.periodic(const Duration(seconds: 2), (timer){
                           if(isCanceled){
                            timer.cancel();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Account deletion canceled"), duration: Duration(seconds: 2),));
                            return;
                           }

                           timerCount--;

                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your account will be deleted after $timerCount seconds"), duration:const Duration(seconds: 1),action: SnackBarAction(label: "Undo", onPressed: (){isCanceled = true;}),));
                           if(timerCount == 0){
                            timer.cancel();
                            deleteUserAccount(user, context);
                            Navigator.pushNamed(context, "login_page");
                           }
                           });

                           

                            
                        },
                        btnOkColor: Colors.blue,
                        btnOkText: "Cancel",
                        btnOkOnPress: () {
                        }
                        ).show();
                    },
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.blue,),),
      );
      }
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
