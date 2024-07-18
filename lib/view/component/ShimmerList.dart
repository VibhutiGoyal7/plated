import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  late int itemCount;
  ShimmerList({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
        itemCount: itemCount, // Adjust the count based on your needs
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                color: Colors.white,),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              height: 46,
              width: 200,
            ),
          ),
                      );
        },

    );
  }
}