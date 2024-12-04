import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  late int itemCount;

  ShimmerList({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor:isDarkMode? Colors.grey[800]! :Colors.grey[300]!,
          highlightColor:isDarkMode? Colors.grey[700]!: Colors.grey[100]!,
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              height: 46,
              width: 300,
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor:isDarkMode? Colors.grey[800]! :Colors.grey[300]!,
          highlightColor:isDarkMode? Colors.grey[700]!: Colors.grey[100]!,
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              height: 46,
              width: 300,
            ),
          ),
        ),
      ],
    );

    /*ListView.builder(
      itemCount: itemCount, // Adjust the count based on your needs
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              height: 46,
              width: 200,
            ),
          ),
        );
      },
    );*/
  }
}
