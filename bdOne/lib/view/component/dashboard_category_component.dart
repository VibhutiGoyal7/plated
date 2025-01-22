import 'package:BDOne/model/response/ServiceTypeResponse.dart';
import 'package:BDOne/theme/AppColor.dart';
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 12),
              child: Text(
                "Services",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        AnimatedContainer(
          width: screenWidth,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: _isExpanded ? 300 : 140,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
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
            children: [
              Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 5,
                  mainAxisSpacing: 10,
                  padding: EdgeInsets.symmetric(vertical: 4),
                  children: [
                    _buildServiceItem(
                        'BD Mart', 'assets/mart_icon.svg', Colors.red.shade50),
                    _buildServiceItem('Cab Booking', 'assets/cab_icon.svg',
                        Colors.yellow.shade50),
                    _buildServiceItem(
                        'Foods', 'assets/food_icon.svg', Colors.green.shade50),
                    _buildServiceItem('Travel ', 'assets/flight_icon.svg',
                        Colors.red.shade50),
                    _isExpanded == false
                        ? _buildServiceItem('More', 'assets/more_icon.svg',
                            Colors.grey.shade300)
                        : _buildServiceItem('Shopping',
                            'assets/shopping_icon.svg', Colors.blue.shade50),
                    if (_isExpanded) ...[
                      _buildServiceItem('Parcel', 'assets/parcel_icon.svg',
                          Colors.red.shade50),
                      _buildServiceItem('Shopping', 'assets/shopping_icon.svg',
                          Colors.purple.shade100),
                      _buildServiceItem(
                          'Digital Wallet',
                          'assets/wallet_icon.svg',
                          Colors.indigoAccent.withOpacity(0.23)),
                      _buildServiceItem('Billing', 'assets/billing_icon.svg',
                          Colors.redAccent.withOpacity(0.3)),
                      _buildServiceItem('Auction', 'assets/auction_icon.svg',
                          Colors.pinkAccent.withOpacity(0.3)),
                      _buildServiceItem('Nursery', 'assets/nursery_icon.svg',
                          Colors.green.shade50),
                      _buildServiceItem('Health', 'assets/health_icon.svg',
                          Colors.blue.shade200),
                      _buildServiceItem(
                          'Home Care',
                          'assets/home_care_icon.svg',
                          Colors.purpleAccent.withOpacity(0.5)),
                      _buildServiceItem('Pets', 'assets/pets_icon.svg',
                          Colors.orangeAccent.withOpacity(0.3)),
                      _isExpanded
                          ? _buildServiceItem('Less', 'assets/more_icon.svg',
                              Colors.grey.shade300)
                          : SizedBox(),
                    ],
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
        } else if (currentCategoryName == "Cab Booking") {
          Navigator.pushNamed(context, "/RideBottomNav");
        }
      },
      child: IntrinsicHeight(
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
    );
  }
}
