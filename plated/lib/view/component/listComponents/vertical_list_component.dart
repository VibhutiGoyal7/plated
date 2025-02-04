import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VerticalListComponent extends StatefulWidget {
  final double height;
  final double width;
  final List<dynamic> list;
  final Widget Function(BuildContext, int) itemBuilder;

  const VerticalListComponent({
    Key? key,
    required this.height,
    required this.width,
    required this.list,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  _VerticalListComponentState createState() =>
      _VerticalListComponentState();
}

class _VerticalListComponentState extends State<VerticalListComponent> {
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
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        //controller: _scrollController,
        itemCount: widget.list.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 5),
        itemBuilder: widget.itemBuilder /*(BuildContext context, int index) {
          return widget.component;
          // I omit the part to build card items from the list
        }*/,
      ),
    );
  }
}
