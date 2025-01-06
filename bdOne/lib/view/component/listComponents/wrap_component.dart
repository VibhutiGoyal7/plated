import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WrapComponent extends StatefulWidget {
  final double height;
  final double width;
  final List<Widget> wrapItems;
  final bool isHorizontal;

  const WrapComponent({
    Key? key,
    required this.height,
    required this.width,
    required this.isHorizontal,
    required this.wrapItems,
  }) : super(key: key);

  @override
  _WrapComponentState createState() =>
      _WrapComponentState();
}

class _WrapComponentState extends State<WrapComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: widget.width,
      height: widget.height,
      child: SingleChildScrollView(
        scrollDirection:widget.isHorizontal ? Axis.horizontal : Axis.vertical,
        child: Wrap(
          spacing: 6,
          alignment: WrapAlignment.start,
          runSpacing: 8,
          children: widget.wrapItems /*widget.list.map((result) {
              return widget.component;
            },
          ).toList()*/,
        ),
      ),
    );
  }
}
