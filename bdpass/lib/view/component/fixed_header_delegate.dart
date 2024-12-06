import 'package:flutter/cupertino.dart';

class FixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  FixedHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 60.0;  // Height of your fixed header
  @override
  double get minExtent => 60.0;  // Height of your fixed header

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}



