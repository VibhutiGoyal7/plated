import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GridLayoutComponent extends StatefulWidget {
  final SliverGridDelegateWithFixedCrossAxisCount sliverGridDelegate;
  final double height;
  final double width;
  final List<dynamic> list;
  final Widget Function(BuildContext, int) itemBuilder;

  const GridLayoutComponent({
    Key? key,
    required this.height,
    required this.width,
    required this.sliverGridDelegate,
    required this.list,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  _GridLayoutComponentState createState() =>
      _GridLayoutComponentState();
}

class _GridLayoutComponentState extends State<GridLayoutComponent> {
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
      width: widget.height,
      height: widget.width,
      child: GridView.builder(
        gridDelegate: widget.sliverGridDelegate /*SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns in the grid
          crossAxisSpacing: 4.0, // Space between columns
          mainAxisSpacing: 4.0, // Space between rows
        )*/,
        itemCount: widget.list.length, // Number of items in the grid
        itemBuilder: widget.itemBuilder /*(context, index) {
          return widget.component;
        }*/,
      ),
    );
  }
}
