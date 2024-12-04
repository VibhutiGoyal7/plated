import 'package:flutter/material.dart';

class CustomButtonComponent extends StatelessWidget {
  late final String text;
  late final bool isDarkMode;
  late final double screenWidth;
  final Function() onTap;

  CustomButtonComponent(
      {required this.text,
      required this.screenWidth,
      required this.isDarkMode,
      required this.onTap});

  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: screenWidth * 0.94,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.8),
            borderRadius: BorderRadius.circular(8),
            color:isDarkMode ? Colors.white :  Colors.black),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color:isDarkMode ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }
}
