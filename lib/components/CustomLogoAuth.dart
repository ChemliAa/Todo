import 'package:flutter/material.dart';

class CustomLogoAuth extends StatelessWidget {
  const CustomLogoAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // Set container background color to transparent
      child: Image.asset(
        'images/todoList.png', // Replace with actual image path
        width: 150, // Adjust image width as needed
        height: 150, // Adjust image height as needed
        fit: BoxFit.contain, // Ensure the image fits within the container
      ),
    );
  }
}
