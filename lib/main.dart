import 'package:e_market/Authentication/login_form.dart';
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
      home: const LogIn()
    );
  }

}
