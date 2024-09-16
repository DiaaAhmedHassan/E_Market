import 'package:flutter/material.dart';

class UserInputField extends StatelessWidget {
   
  UserInputField({super.key, required this.hint, this.suffix, this.prefix, this.inputType,  required this.secureText, this.controller, this.validation, this.onChange, this.onSave});

  final String hint;
  final Widget? suffix;
  final Widget? prefix;
  final TextInputType? inputType;
  bool secureText = false;
  final TextEditingController? controller;
  
  final FormFieldValidator<String>? validation;
  final FormFieldSetter<String>? onSave;
  final ValueChanged<String>? onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSave,
      onChanged: onChange,
      keyboardType: inputType,
      obscureText: secureText,
      validator: validation,
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