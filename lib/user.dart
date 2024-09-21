import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/cart_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MarketUser {
  String? _id;
  String? _email;
  String? _password;
  String? _name;
  String? _phoneNumber;
  String? _imageUrl;

  MarketUser({
    String? id,
    String? email,
    String? password,
    String? name,
    String? phoneNumber,
    String? imageUrl,
  })  : _id = id,
        _email = email,
        _password = password,
        _name = name,
        _phoneNumber = phoneNumber,
        _imageUrl = imageUrl;

  String? get id => _id;
  set id(String? value) => _id = value;

  String? get email => _email;
  set email(String? value) => _email = value;

  String? get password => _password;
  set password(String? value) => _password = value;

  String? get name => _name;
  set name(String? value) => _name = value;

  String? get phoneNumber => _phoneNumber;
  set phoneNumber(String? value) => _phoneNumber = value;

  String? get imageUrl => _imageUrl;
  set imageUrl(String? value) => _imageUrl = value;


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
    DocumentReference users =
        FirebaseFirestore.instance.collection("users").doc(userId);

    users.set({
      "userId": userId,
      "username": name,
      "phoneNumber": phoneNumber,
      "imageUrl": imageUrl ??
          "https://firebasestorage.googleapis.com/v0/b/e-market-cdf14.appspot.com/o/avatar.png?alt=media&token=85646f6b-af57-413d-886d-8eb3557b7f1e"
    });
  }

  Future<bool> signInUsingGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleUser == null) {
      return false;
    }

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final bool isNewUser = userCredential.additionalUserInfo!.isNewUser;
    print("is new user : ========= $isNewUser");
    // Once signed in, return the UserCredential
    if(isNewUser){
    addGoogleUserToDatabase(
        FirebaseAuth.instance.currentUser!.displayName,
        phoneNumber ?? "none", 
        FirebaseAuth.instance.currentUser!.photoURL);
      }else{
        print("Existing user");
      }
    
    return true;
  }

  addGoogleUserToDatabase(String? name, String? phone, String? imageUrl) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference users =
        FirebaseFirestore.instance.collection("users").doc(userId);
    users.set({
      "userId": userId,
      "username": name,
      "PhoneNumber": phone ?? "none",
      "cart": [],
      "imageUrl": imageUrl
    });
  }

  showExistingGoogleUser(String? name, String? phone, String? imageUrl, List? cartItems)async{
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference users = FirebaseFirestore.instance.collection("users").doc(userId);
    DocumentSnapshot snapshot =await users.get();
   print(snapshot['username']);
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

  addProductToCart(CartProduct product) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> productData = product.toMap();
    try {
      FirebaseFirestore.instance.collection("users").doc(userId).set({
        "cart": FieldValue.arrayUnion([productData])
      }, SetOptions(merge: true));
    } catch (e) {
      print("Product addition failed");
    }
  }

  updateProfile(String newImage, String newUserName, String newPhoneNumber){
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference user = FirebaseFirestore.instance.collection("users").doc(userId);
    user.update({"imageUrl": newImage, "username": newUserName, "PhoneNumber": newPhoneNumber});

  }
}
