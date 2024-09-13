import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MarketUser {
  String? email;
  String? password;
  String? name;
  String? phoneNumber;
  String? imageUrl;

  MarketUser(
      {this.email, this.password, this.name, this.phoneNumber, this.imageUrl});

  setName(String name) {
    this.name = name;
  }

  getName() {
    return name;
  }

  setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  getPhoneNumber() {
    return phoneNumber;
  }

  register() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      print(credential);
      addUserToDatabase();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  addUserToDatabase() {
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    users.add({
      "username": name,
      "phoneNumber": phoneNumber,
      "imageUrl": imageUrl ?? "images/avatar.png"
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

      addGoogleUserToDatabase(googleUser.displayName, googleUser.email, googleUser.photoUrl);
      // Once signed in, return the UserCredential
     await FirebaseAuth.instance.signInWithCredential(credential);
     return true;
  }

  addGoogleUserToDatabase(String? name, String? email, String? imageUrl){
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    users.add({
      "username": name,
      "PhoneNumber": "none",
      "imageUrl": imageUrl
    });
  }
  Future<bool> signIn() async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
      print(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      print("invalid credential");
      return false;
    }
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
