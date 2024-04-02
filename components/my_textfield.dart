import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      controller: controller,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          hintText: hintText,
          hintStyle:
              TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic)),
      obscureText: obscureText,
    );
  }
}
