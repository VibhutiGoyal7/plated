import 'package:BDOne/model/response/ServiceTypeResponse.dart';
import 'package:BDOne/theme/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/Util.dart';

class RideDashboardServiceComponent extends StatefulWidget {
  final List<ServiceTypeResponse?> categories;
  final double screenWidth;
  final double screenHeight;
  final Color primaryColor;
  final bool isDarkMode;
  final String heading;

  const RideDashboardServiceComponent({
    Key? key,
    required this.categories,
    required this.screenWidth,
    required this.screenHeight,
    required this.primaryColor,
    required this.isDarkMode,
    required this.heading,
  }) : super(key: key);

  @override
  _RideDashboardServiceComponentState createState() =>
      _RideDashboardServiceComponentState();
}

class _RideDashboardServiceComponentState
    extends State<RideDashboardServiceComponent> {
  bool _isExpanded = false;
  int initialItemCount = 5;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 12),
              child: Text(
                "${widget.heading}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        AnimatedContainer(
          width: screenWidth,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: _isExpanded ? 250 : 140,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          child: Column(
            children: [
              Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  padding: EdgeInsets.symmetric(vertical: 4),
                  children: [
                    _buildServiceItem(
                        'Car', 'assets/car_icon.svg', Colors.yellow.shade50),
                    _buildServiceItem(
                        'Bike', 'assets/bike_icon.svg', Colors.green.shade50),
                    _buildServiceItem(
                        'Auto', 'assets/auto_icon.svg', Colors.green.shade50),
                    _buildServiceItem(
                        'Truck ', 'assets/truck_icon.svg', Colors.red.shade50),
                    /* _isExpanded == false
                        ? _buildServiceItem('More', 'assets/more_icon.svg',
                            Colors.grey.shade300)
                        : _buildServiceItem('Truck ', 'assets/truck_icon.svg',
                            Colors.red.shade50),
                    if (_isExpanded) ...[
                      */ /* _buildServiceItem('Truck ', 'assets/truck_icon.svg',
                          Colors.red.shade50),*/ /*
                      _isExpanded
                          ? _buildServiceItem('Less', 'assets/more_icon.svg',
                              Colors.grey.shade300)
                          : SizedBox(),
                    ],*/
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

    /*IntrinsicHeight(
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
    );*/
  }

  Widget _buildServiceItem(String? currentCategoryName, String? currentIcon,
      Color? currentIconBdColor) {
    return GestureDetector(
      onTap: () {
        if (currentCategoryName == "More" || currentCategoryName == "Less") {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        } else if (currentCategoryName == "Car") {
          Navigator.pushNamed(context, "/BookRideScreen");
        }
      },
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.WHITE,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                offset: Offset(0, 0),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: currentCategoryName == "More" ||
                        currentCategoryName == "Less"
                    ? 48
                    : 70,
                width: 70,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(100),
                    //color: currentIconBdColor,
                    ),
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
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  capitalizeFirstLetter("${currentCategoryName}"),
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
