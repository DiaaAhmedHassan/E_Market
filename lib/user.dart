import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MarketUser {
  String? id;
  String? email;
  String? password;
  String? name;
  String? phoneNumber;
  String? imageUrl;

  MarketUser(
      {this.id, this.email, this.password, this.name, this.phoneNumber, this.imageUrl});

  setId(String id){
    this.id = id;
  }    

  getId(){
    return id;
  }

  setName(String name) {
    this.name = name;
  }

  getName() {
    return name;
  }

  setEmail(String email){
    this.email = email;
  }

  getEmail(){
    return email;
  }

  setPassword(String password){
    this.password = password;
  }

  getPassword(){
    return password;
  }

  setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  getPhoneNumber() {
    return phoneNumber;
  }

   setImage(String imageUrl){
    this.imageUrl = imageUrl;
  }

  getImage(){
    return imageUrl;
  }

  Future<bool> register() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      print(credential);
      addUserToDatabase();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  addUserToDatabase() {
   String userId = FirebaseAuth.instance.currentUser!.uid;
  DocumentReference users = FirebaseFirestore.instance.collection("users").doc(userId);
    
    users.set({
      "userId": userId,
      "username": name,
      "phoneNumber": phoneNumber,
      "imageUrl": imageUrl ?? "https://firebasestorage.googleapis.com/v0/b/e-market-cdf14.appspot.com/o/avatar.png?alt=media&token=85646f6b-af57-413d-886d-8eb3557b7f1e"
    });
  }

  Future<bool> signInUsingGoogle()async{
     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

          if(googleUser == null){
            return false;
          }

    
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
     await FirebaseAuth.instance.signInWithCredential(credential);
      addGoogleUserToDatabase(FirebaseAuth.instance.currentUser!.displayName, phoneNumber??"none", FirebaseAuth.instance.currentUser!.photoURL);
     return true;
  }

  addGoogleUserToDatabase(String? name, String? phone, String? imageUrl){
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference users = FirebaseFirestore.instance.collection("users").doc(userId);
    users.set(
      {
      "userId": userId,
      "username": name,
      "PhoneNumber": phone??"none",
      "imageUrl": imageUrl
    });
  }
  Future<bool> signIn() async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
      print(credential);
      return true;
    } on FirebaseAuthException {
      print("invalid credential");
      return false;
    }
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  addProductToCart(Product product, int requiredAmount){
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> productData = product.productToMap(requiredAmount);
    try{

    FirebaseFirestore.instance.collection("users").doc(userId).set({"cart":  FieldValue.arrayUnion([productData])}, SetOptions(merge: true));
    }catch(e){
      print("Product addition failed");
    }
  }

}
