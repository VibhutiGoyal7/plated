import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: 3, // Adjust the count based on your needs
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
              color: Colors.white,),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            height: 42,
            width: 200,
          ),
        );
      },

    );
  }
}