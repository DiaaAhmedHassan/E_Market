import 'package:flutter/material.dart';

class UserInputField extends StatelessWidget {
   
  UserInputField({super.key, required this.hint, this.suffix, this.prefix, this.inputType,  required this.secureText});

  final String hint;
  final Widget? suffix;
  final Widget? prefix;
  final TextInputType? inputType;
  bool secureText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      obscureText: secureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300],
        hintText: hint,
        contentPadding: const EdgeInsets.all(5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        suffixIcon: suffix,
        prefixIcon: prefix,
      ),
      
    );
  }
}