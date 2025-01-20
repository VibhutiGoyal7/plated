import 'package:BDOne/model/response/ServiceTypeResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/Util.dart';

class DashboardCategoryComponent extends StatefulWidget {
  final List<ServiceTypeResponse?> categories;
  final double screenWidth;
  final double screenHeight;
  final Color primaryColor;
  final bool isDarkMode;


  const DashboardCategoryComponent({
    Key? key,
    required this.categories,
    required this.screenWidth,
    required this.screenHeight,
    required this.primaryColor,
    required this.isDarkMode,
  }) : super(key: key);
  @override
  _DashboardCategoryState createState() => _DashboardCategoryState();
}

class _DashboardCategoryState extends State<DashboardCategoryComponent> {

  bool _isExpanded = false;
  int initialItemCount = 5;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return IntrinsicHeight(
      child: Column(
        children: [
          Container(
            width: screenWidth,
            alignment: Alignment.center,
            child: Wrap(
              spacing: 5,
              alignment: WrapAlignment.start,
              runSpacing: 8,
              children: widget.categories.map((result) {
                var currentItem = result;
                var currentCategoryName = currentItem?.serviceName;
                var currentIcon = currentItem?.icon;
                var currentIconBdColor = currentItem?.iconBgColor;
                return _buildServiceItem(
                    currentCategoryName, currentIcon, currentIconBdColor);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String? currentCategoryName, String? currentIcon,
      Color? currentIconBdColor)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        padding: EdgeInsets.only(bottom: 4, top: 2, left: 2, right: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 48,
              width: 48,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: currentIconBdColor),
              child: SvgPicture.asset(
                "$currentIcon",
                colorFilter: ColorFilter.mode(
                  Colors.transparent,
                  // Use a contrasting color to test visibility
                  BlendMode.dst,
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                capitalizeFirstLetter("${currentCategoryName}"),
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
