import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBoxes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        2,
        (index) {
          return _buildShimmerBox();
        },
      ),
    );
  }

  Widget _buildShimmerBox() {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: 80,
            child: Center(
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  margin: EdgeInsets.zero),
            )
        )
    );
  }
}
