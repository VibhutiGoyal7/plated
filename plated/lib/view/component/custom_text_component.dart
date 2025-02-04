import 'package:flutter/material.dart';

class CustomTextComponent extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color? fontColor;
  final bool isBold;

  const CustomTextComponent({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.fontColor,
    required this.isBold,
  }) : super(key: key);

  @override
  _CustomTextComponentState createState() => _CustomTextComponentState();
}

class _CustomTextComponentState extends State<CustomTextComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Text(
      "${widget.text}",
      style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.isBold ? FontWeight.bold : FontWeight.normal,
          color: widget.fontColor),
    );
  }
}
