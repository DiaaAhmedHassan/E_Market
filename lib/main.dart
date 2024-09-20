import 'package:e_market/Auths/login_form.dart';
import 'package:e_market/Auths/registration.dart';
import 'package:e_market/cart_page.dart';
import 'package:e_market/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();

FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        fontFamily: 'Dosis',
        appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold, fontFamily: "Dosis"),
        
      )),
      home:  FirebaseAuth.instance.currentUser == null ?const LogIn(): const HomePage(),

      routes: {
        "home_page": (route)=> const HomePage(),
        "login_page": (route)=> const LogIn(),
        "registration_page": (route)=> const Registration(),
        "cart_page": (route) => const CartPage()
      },
    );
  }

}
