import 'package:e_market/Auths/login_form.dart';
import 'package:e_market/Auths/registration.dart';
import 'package:e_market/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
        
      )),
      home: const LogIn(),

      routes: {
        "home_page": (route)=> const HomePage(),
        "login_page": (route)=> const LogIn(),
        "registration_page": (route)=> Registration(),
      },
    );
  }

}
