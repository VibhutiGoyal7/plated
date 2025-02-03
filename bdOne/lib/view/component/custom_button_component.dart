import 'package:flutter/material.dart';

class CustomButtonComponent extends StatefulWidget {
  late bool isClickable = true;
  late double borderRadius = 8;
  late final String text;
  late final bool isDarkMode;
  late final Color buttonColor;
  late final Color textColor;
  late final double width;
  late final double verticalPadding;
  final Function() onTap;

  CustomButtonComponent(
      {this.isClickable = true,
      required this.text,
      required this.width,
      required this.textColor,
      required this.buttonColor,
      this.borderRadius = 8,
      required this.isDarkMode,
      required this.verticalPadding,
      required this.onTap});

  @override
  _CustomButtonComponentState createState() => _CustomButtonComponentState();
}

class _CustomButtonComponentState extends State<CustomButtonComponent> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.isClickable ? widget.onTap : null,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        padding: EdgeInsets.symmetric(
            horizontal: 14, vertical: widget.verticalPadding),
        width: widget.width,
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).focusColor, width: 0.08),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: isDarkMode
                ? widget.isClickable
                    ? widget.buttonColor
                    : Colors.grey
                : widget.isClickable
                    ? widget.buttonColor
                    : Colors.grey),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: widget.textColor),
          ),
        ),
      ),
    );
  }
}
