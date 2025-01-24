import 'package:BDOne/model/response/ServiceTypeResponse.dart';
import 'package:BDOne/theme/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/Util.dart';
import '../image_view_components.dart';

class RestaurantDashboardComponent extends StatefulWidget {
  final List<ServiceTypeResponse?> categories;
  final double screenWidth;
  final double screenHeight;
  final Color primaryColor;
  final bool isDarkMode;
  final String heading;

  const RestaurantDashboardComponent({
    Key? key,
    required this.categories,
    required this.screenWidth,
    required this.screenHeight,
    required this.primaryColor,
    required this.isDarkMode,
    required this.heading,
  }) : super(key: key);

  @override
  _RestaurantDashboardComponentState createState() =>
      _RestaurantDashboardComponentState();
}

class _RestaurantDashboardComponentState
    extends State<RestaurantDashboardComponent> {
  bool _isExpanded = false;
  bool isDarkMode = false;
  late double screenWidth;
  late double screenHeight;
  int initialItemCount = 5;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
            // Expandable height control
            child: GridView.builder(
              shrinkWrap: true,
              // Fit grid inside list
              physics: NeverScrollableScrollPhysics(),
              // Disable grid scrolling
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 items per row
                crossAxisSpacing: 5,
                mainAxisSpacing: 4,
                childAspectRatio: 0.9,
              ),
              padding: EdgeInsets.all(4),
              itemCount: widget.categories.length,
              itemBuilder: (context, subIndex) {
                if (subIndex < widget.categories.length) {
                  var subCategory = widget.categories[subIndex];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        showSnackBar(
                          context,
                          "${subCategory?.serviceName}",
                          screenWidth * 0.5,
                        );
                      });
                    },
                    child: Container(
                      height: 54,
                      width: 40,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 1),
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ImageViewComponent(
                            height: 60,
                            width: 60,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            imageUrl: subCategory?.icon,
                            isDarkMode: false,
                            placeholderImage: "assets/category_image.png",
                          ),
                          Container(
                            //width: 58,
                            alignment: Alignment.center,
                            child: Text(
                              "${capitalizeFirstLetter("${subCategory?.serviceName}")}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode
                                    ? AppColor.WHITE
                                    : AppColor.BLACK,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox(); // Prevents index errors
                }
              },
            ))
      ],
    );

  }
}
