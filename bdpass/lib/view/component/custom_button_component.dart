import 'package:flutter/material.dart';

class CustomButtonComponent extends StatelessWidget {
  late bool isClickable = true;
  late final String text;
  late final bool isDarkMode;
  late final double screenWidth;
  final Function() onTap;

  CustomButtonComponent(
      {this.isClickable = true,
      required this.text,
      required this.screenWidth,
      required this.isDarkMode,
      required this.onTap});

  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: screenWidth,
        decoration: BoxDecoration(
            border: Border.all(
                color: isDarkMode
                    ? isClickable
                        ? Colors.white
                        : Colors.grey
                    : isClickable
                        ? Colors.black
                        : Colors.grey,
                width: 0.8),
            borderRadius: BorderRadius.circular(8),
            color: isDarkMode
                ? isClickable
                    ? Colors.white
                    : Colors.grey
                : isClickable
                    ? Colors.black
                    : Colors.grey),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isDarkMode ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }
}
