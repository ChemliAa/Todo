import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  final IconData? prefixIcon;

  const CustomTextForm({
    Key? key,
    required this.hinttext,
    required this.mycontroller,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mycontroller,
      style: TextStyle(fontSize: 14, color: Colors.black), // Text style for entered text
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Adjust padding
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Adjust border radius
          borderSide: BorderSide.none, // No visible border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Adjust border radius
          borderSide: BorderSide.none, // No visible border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Adjust border radius
          borderSide: const BorderSide(color: Colors.blue, width: 2), // Custom focused border
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null, // Add prefix icon if provided
      ),
    );
  }
}
