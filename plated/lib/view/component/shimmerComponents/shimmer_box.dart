import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBoxes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      height: 125,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        //controller: _scrollController,
        itemCount: 1,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 5),
        itemBuilder: (BuildContext context, int index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: screenWidth / 2.8,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                margin: EdgeInsets.zero,
              ),
            ),
          );
          // I omit the part to build card items from the list
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
