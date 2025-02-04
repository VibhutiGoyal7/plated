import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TextComponent extends StatefulWidget {
  final String text;
  final double fontSize;
  final bool isBold;

  const TextComponent({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.isBold,
  }) : super(key: key);

  @override
  _TextComponentState createState() =>
      _TextComponentState();
}

class _TextComponentState extends State<TextComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Text("${widget.text}", style: TextStyle(fontSize: widget.fontSize, fontWeight: widget.isBold ? FontWeight.bold : FontWeight.normal),);
  }
}
